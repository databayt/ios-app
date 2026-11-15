import Foundation

/// Base-URL resolution + URL joining (pure, unit-tested)
enum APIConfig {
    static let defaultBaseURL = "https://balqalam.com/api"

    /// `HWAPIBaseURL` from Info.plist; falls back to production when missing, empty,
    /// unexpanded (`$(HOGWARTS_API_BASE)`) or not an http(s) URL.
    static func resolveBaseURL(_ raw: Any?) -> URL {
        let fallback = URL(string: defaultBaseURL)!
        guard var value = (raw as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty, !value.contains("$(") else { return fallback }
        while value.hasSuffix("/") { value.removeLast() }
        guard let url = URL(string: value),
              let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https",
              url.host != nil else { return fallback }
        return url
    }

    static var baseURL: URL {
        resolveBaseURL(Bundle.main.object(forInfoDictionaryKey: "HWAPIBaseURL"))
    }

    /// Join base + path ("/x", "x", or "x?a=b") + extra query items.
    static func makeURL(base: URL, path: String, query: [String: String]? = nil) -> URL {
        var root = base.absoluteString
        while root.hasSuffix("/") { root.removeLast() }
        var trimmed = Substring(path)
        while trimmed.hasPrefix("/") { trimmed = trimmed.dropFirst() }
        guard var components = URLComponents(string: root + "/" + trimmed) else { return base }
        if let query, !query.isEmpty {
            var items = components.queryItems ?? []
            items += query.sorted { $0.key < $1.key }.map { URLQueryItem(name: $0.key, value: $0.value) }
            components.queryItems = items
        }
        return components.url ?? base
    }
}

/// Result of a token refresh attempt (reported by AuthManager)
enum RefreshOutcome: Sendable {
    case refreshed
    /// Refresh token rejected (401/403): the session is over
    case sessionOver
    /// Network / server trouble: keep the session, fail this request
    case transient
}

/// API client for Hogwarts backend
/// Mirrors: Server actions pattern from actions.ts files
actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let baseURL: URL
    private let keychain = KeychainService()

    /// Called when the session is over (refresh rejected / no way to refresh)
    private var onUnauthorized: (@Sendable () async -> Void)?

    /// Dynamic authorization token provider (injected by AuthManager)
    private var authorizationProvider: (@Sendable () -> String?)?

    /// Refreshes the token (injected by AuthManager)
    private var refreshHandler: (@Sendable () async -> RefreshOutcome)?

    /// The single in-flight refresh; concurrent 401s await it instead of starting another
    private var refreshTask: Task<RefreshOutcome, Never>?

    private init() {
        self.baseURL = APIConfig.baseURL

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }

    /// Set callback for an ended session
    func setOnUnauthorized(_ handler: @escaping @Sendable () async -> Void) {
        self.onUnauthorized = handler
    }

    /// Set dynamic token provider (AuthManager injects this for proactive refresh)
    func setAuthorizationProvider(_ provider: @escaping @Sendable () -> String?) {
        self.authorizationProvider = provider
    }

    /// Set the refresh handler used on a 401
    func setRefreshHandler(_ handler: @escaping @Sendable () async -> RefreshOutcome) {
        self.refreshHandler = handler
    }

    private func currentToken() -> String? {
        authorizationProvider?() ?? keychain.get(.accessToken)
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

    /// POST request
    func post<T: Decodable, B: Encodable>(
        _ path: String,
        body: B,
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .post, body: body)
    }

    /// PUT request
    func put<T: Decodable, B: Encodable>(
        _ path: String,
        body: B,
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .put, body: body)
    }

    /// PATCH request
    func patch<T: Decodable, B: Encodable>(
        _ path: String,
        body: B,
        as type: T.Type = T.self
    ) async throws -> T {
        try await request(path, method: .patch, body: body)
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
        body: (any Encodable)? = nil
    ) async throws -> T {
        let maxAttempts = 3
        var lastError: Error?

        for attempt in 0..<maxAttempts {
            if attempt > 0 {
                let delay = pow(2.0, Double(attempt - 1))
                try? await Task.sleep(for: .seconds(delay))
            }

            do {
                return try await performRequest(path, method: method, query: query, body: body)
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

    /// Send once; on 401 try ONE serialized refresh, retry once, else end the session.
    private func performRequest<T: Decodable>(
        _ path: String,
        method: HTTPMethod,
        query: [String: String]? = nil,
        body: (any Encodable)? = nil
    ) async throws -> T {
        let token = currentToken()
        do {
            return try await send(path, method: method, query: query, body: body, token: token)
        } catch APIError.unauthorized {
            guard token != nil, refreshHandler != nil else {
                await onUnauthorized?()
                throw APIError.unauthorized
            }
            switch await refresh(staleToken: token) {
            case .refreshed:
                do {
                    return try await send(path, method: method, query: query, body: body, token: currentToken())
                } catch APIError.unauthorized {
                    await onUnauthorized?()
                    throw APIError.unauthorized
                }
            case .sessionOver:
                await onUnauthorized?()
                throw APIError.unauthorized
            case .transient:
                throw APIError.unauthorized
            }
        }
    }

    /// Serialized refresh: concurrent callers share one in-flight task
    private func refresh(staleToken: String?) async -> RefreshOutcome {
        // Another request already refreshed while this one was in flight
        if let current = currentToken(), current != staleToken { return .refreshed }
        if let running = refreshTask { return await running.value }
        guard let handler = refreshHandler else { return .sessionOver }
        let task = Task { await handler() }
        refreshTask = task
        let outcome = await task.value
        refreshTask = nil
        return outcome
    }

    private func send<T: Decodable>(
        _ path: String,
        method: HTTPMethod,
        query: [String: String]?,
        body: (any Encodable)?,
        token: String?
    ) async throws -> T {
        let url = APIConfig.makeURL(base: baseURL, path: path, query: query)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Add body
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        case 401:
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

    // MARK: - Unauthenticated (auth endpoints)

    /// Request without the bearer header and without the 401-refresh path.
    /// Non-2xx throws `APIError.http` carrying the server's `{error, code}` body.
    func authRequest<T: Decodable>(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: (any Encodable)? = nil,
        as type: T.Type = T.self
    ) async throws -> T {
        var request = URLRequest(url: APIConfig.makeURL(base: baseURL, path: path))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key) }
        if let body { request.httpBody = try JSONEncoder().encode(body) }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }

        guard (200...299).contains(http.statusCode) else {
            let payload = try? JSONDecoder().decode(ServerErrorBody.self, from: data)
            throw APIError.http(status: http.statusCode, code: payload?.code, message: payload?.error)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Device Token Registration

    func registerDeviceToken(_ token: String) async throws {
        struct TokenRequest: Encodable {
            let deviceToken: String
            let platform: String = "ios"
        }

        let _: EmptyResponse = try await post(
            "/notifications/register",
            body: TokenRequest(deviceToken: token)
        )
    }
}

// MARK: - Supporting Types

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct EmptyResponse: Decodable {}

/// `{ "error": "...", "code": "..." }` — the mobile API's error body
struct ServerErrorBody: Decodable {
    let error: String?
    let code: String?
}

struct ValidationError: Decodable {
    let message: String
    let errors: [String: [String]]?
}

enum APIError: LocalizedError {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case validationFailed(String)
    case serverError(Int)
    case unknown(Int)
    case networkError(Error)
    /// Non-2xx from an auth endpoint, with the server's code/message
    case http(status: Int, code: String?, message: String?)

    var errorDescription: String? {
        switch self {
        case .http(let status, _, let message):
            return message ?? String(localized: "error.api.unknownError \(status)")
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
