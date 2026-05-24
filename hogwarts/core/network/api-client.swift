import Foundation

// MARK: - Protocol Seam

/// Protocol surface of `APIClient`, used by services and view models so tests
/// can swap in an in-memory fake without reaching for `APIClient.shared`.
/// All methods are async-throws; the actor isolation lives on the conformance.
/// `T: Sendable` is required so Swift 6 strict concurrency lets the metatype
/// cross actor boundaries without a warning.
protocol APIClientProtocol: Sendable {
    func get<T: Decodable & Sendable>(_ path: String, as type: T.Type) async throws -> T
    func get<T: Decodable & Sendable>(_ path: String, query: [String: String], as type: T.Type) async throws -> T

    func post<T: Decodable & Sendable, B: Encodable & Sendable>(_ path: String, body: B, as type: T.Type) async throws -> T
    func put<T: Decodable & Sendable, B: Encodable & Sendable>(_ path: String, body: B, as type: T.Type) async throws -> T

    /// Send already-encoded JSON bytes. Used by the offline mutation queue
    /// so a queued payload is replayed verbatim, with no re-encoding.
    func postRaw(_ path: String, jsonBody: Data?) async throws
    func putRaw(_ path: String, jsonBody: Data?) async throws

    func delete(_ path: String) async throws

    func setOnUnauthorized(_ handler: @escaping @Sendable () async -> Void) async
    func setAuthorizationProvider(_ provider: @escaping @Sendable () -> String?) async
}

// MARK: - Implementation

/// API client for Hogwarts backend.
/// Talks to https://ed.databayt.org/api — every business call is expected
/// to use the `/mobile/...` namespace; the JWT carries `schoolId`, so we
/// never pass `schoolId` as a query param.
actor APIClient: APIClientProtocol {
    static let shared = APIClient()

    private let session: URLSession
    private let baseURL: URL
    private let keychain = KeychainService()

    /// Called when a 401 response is received
    private var onUnauthorized: (@Sendable () async -> Void)?

    /// Dynamic authorization token provider (injected by AuthManager)
    private var authorizationProvider: (@Sendable () -> String?)?

    private init() {
        guard let url = URL(string: "https://ed.databayt.org/api") else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    /// Set callback for 401 responses
    func setOnUnauthorized(_ handler: @escaping @Sendable () async -> Void) {
        self.onUnauthorized = handler
    }

    /// Set dynamic token provider (AuthManager injects this for proactive refresh)
    func setAuthorizationProvider(_ provider: @escaping @Sendable () -> String?) {
        self.authorizationProvider = provider
    }

    // MARK: - HTTP Methods

    /// GET request
    func get<T: Decodable>(_ path: String, as type: T.Type = T.self) async throws -> T {
        try await request(path, method: .get)
    }

    /// GET with query parameters
    func get<T: Decodable>(
        _ path: String,
        query: [String: String],
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .get, query: query)
    }

    /// POST request — body is encoded by JSONEncoder
    func post<T: Decodable, B: Encodable>(
        _ path: String,
        body: B,
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .post, body: body)
    }

    /// PUT request — body is encoded by JSONEncoder
    func put<T: Decodable, B: Encodable>(
        _ path: String,
        body: B,
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .put, body: body)
    }

    /// POST already-encoded bytes — used to replay queued offline mutations
    /// without round-tripping through `Encodable` a second time.
    func postRaw(_ path: String, jsonBody: Data?) async throws {
        let _: EmptyResponse = try await request(path, method: .post, rawBody: jsonBody)
    }

    /// PUT already-encoded bytes — sibling of `postRaw`.
    func putRaw(_ path: String, jsonBody: Data?) async throws {
        let _: EmptyResponse = try await request(path, method: .put, rawBody: jsonBody)
    }

    /// DELETE request
    func delete(_ path: String) async throws {
        let _: EmptyResponse = try await request(path, method: .delete)
    }

    // MARK: - Core Request (with transient error retry)

    private func request<T: Decodable>(
        _ path: String,
        method: HTTPMethod,
        query: [String: String]? = nil,
        body: (any Encodable)? = nil,
        rawBody: Data? = nil
    ) async throws -> T {
        let maxAttempts = 3
        var lastError: Error?

        for attempt in 0..<maxAttempts {
            if attempt > 0 {
                let delay = pow(2.0, Double(attempt - 1))
                try? await Task.sleep(for: .seconds(delay))
            }

            do {
                return try await performRequest(
                    path,
                    method: method,
                    query: query,
                    body: body,
                    rawBody: rawBody
                )
            } catch let error as APIError {
                if case .serverError(let code) = error,
                   [500, 502, 503].contains(code),
                   attempt < maxAttempts - 1 {
                    lastError = error
                    continue
                }
                throw error
            } catch {
                if attempt < maxAttempts - 1,
                   (error as NSError).domain == NSURLErrorDomain {
                    lastError = error
                    continue
                }
                throw error
            }
        }

        throw lastError ?? APIError.unknown(0)
    }

    private func performRequest<T: Decodable>(
        _ path: String,
        method: HTTPMethod,
        query: [String: String]? = nil,
        body: (any Encodable)? = nil,
        rawBody: Data? = nil
    ) async throws -> T {
        var url = baseURL.appendingPathComponent(path)

        if let query = query, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components.url ?? url
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Self.acceptLanguageHeader(), forHTTPHeaderField: "Accept-Language")

        if let token = authorizationProvider?() ?? keychain.get(.accessToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // rawBody wins over body — used by the offline queue to replay bytes
        // verbatim. Keeps a single source of truth for the payload format.
        if let rawBody {
            request.httpBody = rawBody
        } else if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            // Empty 2xx (e.g. 204) — synthesize an empty object so callers
            // expecting `EmptyResponse` succeed without a decoder error.
            if data.isEmpty, T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        case 401:
            await onUnauthorized?()
            throw APIError.unauthorized

        case 403:
            throw APIError.forbidden

        case 404:
            throw APIError.notFound

        case 422:
            let error = try? JSONDecoder().decode(ValidationError.self, from: data)
            throw APIError.validationFailed(error?.message ?? "Validation failed")

        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)

        default:
            throw APIError.unknown(httpResponse.statusCode)
        }
    }

    // MARK: - Auth Refresh (header-based)

    /// Refresh auth session — PUT /mobile/auth with X-Refresh-Token header
    func refreshAuth(refreshToken: String) async throws -> Session {
        let url = baseURL.appendingPathComponent("/mobile/auth")

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Self.acceptLanguageHeader(), forHTTPHeaderField: "Accept-Language")
        request.setValue(refreshToken, forHTTPHeaderField: "X-Refresh-Token")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            throw APIError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Session.self, from: data)
    }

    // MARK: - Device Token Registration

    func registerDeviceToken(_ token: String) async throws {
        struct TokenRequest: Encodable {
            let deviceToken: String
            let platform: String = "ios"
        }

        let _: EmptyResponse = try await post(
            "/mobile/notifications/register",
            body: TokenRequest(deviceToken: token)
        )
    }

    // MARK: - Locale

    /// Locale override key — read from UserDefaults so the in-app language
    /// toggle (set via @AppStorage("selectedLanguage")) is honored on every
    /// request. Falls back to the system preferred locale when unset.
    private static func acceptLanguageHeader() -> String {
        let override = UserDefaults.standard.string(forKey: "selectedLanguage")
        let identifier = override?.isEmpty == false
            ? override!
            : (Locale.preferredLanguages.first ?? Locale.current.identifier)
        return Self.bcp47(from: identifier)
    }

    /// Normalize identifiers like "ar_SA" or "ar-SA-u-ca-gregorian" to the
    /// BCP-47 form servers expect (e.g. "ar-SA").
    private static func bcp47(from identifier: String) -> String {
        let normalized = identifier.replacingOccurrences(of: "_", with: "-")
        if let range = normalized.range(of: "-u-") {
            return String(normalized[..<range.lowerBound])
        }
        return normalized
    }
}

// MARK: - Supporting Types

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct EmptyResponse: Decodable, Sendable {}

struct ValidationError: Decodable, Sendable {
    let message: String
    let errors: [String: [String]]?
}

enum APIError: LocalizedError, Sendable {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case validationFailed(String)
    case serverError(Int)
    case unknown(Int)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return String(localized: "error.api.invalidResponse")
        case .unauthorized:
            return String(localized: "error.api.unauthorized")
        case .forbidden:
            return String(localized: "error.api.forbidden")
        case .notFound:
            return String(localized: "error.api.notFound")
        case .validationFailed(let message):
            return message
        case .serverError(let code):
            return String(localized: "error.api.serverError \(code)")
        case .unknown(let code):
            return String(localized: "error.api.unknownError \(code)")
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
