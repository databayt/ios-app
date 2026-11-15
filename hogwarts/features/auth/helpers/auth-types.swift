import Foundation

// MARK: - Session

/// Authenticated session from API
/// Mirrors: NextAuth session object
struct Session: Codable {
    let user: User
    let schoolId: String?
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date?
}

// MARK: - Request Types

/// Body of `POST /mobile/auth`. `school` is only sent for login codes / usernames.
struct SignInRequest: Encodable {
    let identifier: String
    let password: String
    let school: String?

    init(identifier: String, password: String, school: String? = nil) {
        self.identifier = identifier
        self.password = password
        self.school = school
    }

    /// `school` is omitted (not null) when absent, like Android.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(password, forKey: .password)
        try container.encodeIfPresent(school, forKey: .school)
    }

    private enum CodingKeys: String, CodingKey { case identifier, password, school }
}

struct OAuthSignInRequest: Encodable {
    let provider: String
    let token: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

// MARK: - Mobile auth response (production contract)

/// Response of `POST` / `PUT /api/mobile/auth`.
/// Mirrors: hogwarts/src/app/api/mobile/auth/jwt.ts `buildAuthResponse`
struct MobileAuthResponse: Decodable, Equatable {
    let accessToken: String
    let refreshToken: String
    /// Epoch milliseconds
    let expiresAt: Double
    let user: MobileAuthUser

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case user
    }

    /// Map the wire payload into the app's `Session` / `User` models.
    func toSession() -> Session {
        let schoolId = user.schoolId ?? TokenPayload.decode(from: accessToken)?.schoolId
        let mapped = User(
            id: user.id,
            email: user.email ?? "",
            name: user.displayName,
            nameAr: nil,
            role: RoleMapping.normalize(user.role),
            schoolId: schoolId,
            imageUrl: user.avatarUrl,
            phone: nil,
            emailVerified: nil,
            isTwoFactorEnabled: nil,
            createdAt: nil,
            updatedAt: nil
        )
        return Session(
            user: mapped,
            schoolId: schoolId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: Date(timeIntervalSince1970: expiresAt / 1000)
        )
    }
}

struct MobileAuthUser: Decodable, Equatable {
    let id: String
    let email: String?
    let schoolId: String?
    let role: String?
    let givenName: String?
    let familyName: String?
    let avatarUrl: String?
    let grade: String?

    enum CodingKeys: String, CodingKey {
        case id, email, role, grade
        case schoolId = "school_id"
        case givenName = "given_name"
        case familyName = "family_name"
        case avatarUrl = "avatar_url"
    }

    /// "given family", nil when both are empty.
    var displayName: String? {
        let full = [givenName, familyName]
            .compactMap { $0?.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        return full.isEmpty ? nil : full
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        email = try c.decodeIfPresent(String.self, forKey: .email)
        schoolId = try c.decodeIfPresent(String.self, forKey: .schoolId)
        role = try c.decodeIfPresent(String.self, forKey: .role)
        givenName = try c.decodeIfPresent(String.self, forKey: .givenName)
        familyName = try c.decodeIfPresent(String.self, forKey: .familyName)
        avatarUrl = try c.decodeIfPresent(String.self, forKey: .avatarUrl)
        // grade may be a string or a number on the server; tolerate both
        if let s = try? c.decodeIfPresent(String.self, forKey: .grade) {
            grade = s
        } else if let n = try? c.decodeIfPresent(Int.self, forKey: .grade) {
            grade = String(n)
        } else {
            grade = nil
        }
    }

    init(id: String, email: String? = nil, schoolId: String? = nil, role: String? = nil,
         givenName: String? = nil, familyName: String? = nil, avatarUrl: String? = nil, grade: String? = nil) {
        self.id = id; self.email = email; self.schoolId = schoolId; self.role = role
        self.givenName = givenName; self.familyName = familyName
        self.avatarUrl = avatarUrl; self.grade = grade
    }
}

// MARK: - Role mapping

enum RoleMapping {
    /// The server sends uppercase roles (TEACHER, STUDENT, ...). `UserRole` raw values are the same
    /// strings, so normalizing = trim + uppercase; anything unknown becomes USER (default dashboard).
    static func normalize(_ raw: String?) -> String {
        let value = raw?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? ""
        return UserRole(rawValue: value) != nil ? value : UserRole.user.rawValue
    }
}

// MARK: - Session State

enum SessionState {
    case authenticated
    case expired
    case unauthenticated
}

// MARK: - Token Payload

/// Decoded JWT payload (base64 decode, no external library)
struct TokenPayload {
    let sub: String
    let exp: Date
    let schoolId: String?

    /// Token is expired
    var isExpired: Bool {
        Date() >= exp
    }

    /// Token should be proactively refreshed (at 80% of lifetime)
    /// Uses iat if available, otherwise assumes 1-hour lifetime
    func shouldRefresh(issuedAt: Date? = nil) -> Bool {
        let now = Date()
        let issueDate = issuedAt ?? exp.addingTimeInterval(-3600)
        let lifetime = exp.timeIntervalSince(issueDate)
        let elapsed = now.timeIntervalSince(issueDate)
        return elapsed >= lifetime * 0.8
    }

    /// Decode a JWT access token into TokenPayload
    /// JWT format: header.payload.signature (base64url encoded)
    static func decode(from jwt: String) -> TokenPayload? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return nil }

        let payloadSegment = String(segments[1])
        guard let data = base64URLDecode(payloadSegment) else { return nil }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let sub = json["sub"] as? String,
              let expValue = json["exp"] as? TimeInterval else {
            return nil
        }

        let exp = Date(timeIntervalSince1970: expValue)
        let schoolId = json["schoolId"] as? String

        return TokenPayload(sub: sub, exp: exp, schoolId: schoolId)
    }

    /// Base64URL decode (JWT uses URL-safe base64 without padding)
    private static func base64URLDecode(_ string: String) -> Data? {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Add padding if needed
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(contentsOf: String(repeating: "=", count: 4 - remainder))
        }

        return Data(base64Encoded: base64)
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case invalidCredentials
    case unauthorized
    case sessionExpired
    case refreshFailed
    case networkError(Error)
    /// 400 SCHOOL_REQUIRED: a login code needs a school
    case schoolRequired
    case tooManyAttempts
    case suspended
    /// 401 with the server's own message (e.g. OAuth-only account)
    case rejected(String)
    case offline

    var errorDescription: String? {
        switch self {
        case .schoolRequired:
            return String(localized: "auth.error.schoolRequired", defaultValue: "Enter your school's name")
        case .tooManyAttempts:
            return String(localized: "auth.error.tooManyRequests", defaultValue: "Too many requests. Please try again in a minute.")
        case .suspended:
            return String(localized: "auth.error.suspended", defaultValue: "Your account has been disabled")
        case .rejected(let message):
            return message
        case .offline:
            return String(localized: "auth.error.network", defaultValue: "Network error. Check your connection")
        case .invalidCredentials:
            return String(localized: "auth.error.invalidCredentials")
        case .unauthorized:
            return String(localized: "auth.error.unauthorized")
        case .sessionExpired:
            return String(localized: "session_expired")
        case .refreshFailed:
            return String(localized: "auth.error.refreshFailed")
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
