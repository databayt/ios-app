import SwiftUI
import AuthenticationServices

/// Authentication manager
/// Mirrors: src/auth.ts + src/auth.config.ts
@Observable
@MainActor
final class AuthManager {
    private let keychain = KeychainService()
    private let api = APIClient.shared

    /// Current authenticated user
    var currentUser: User?

    /// Current session
    var session: Session?

    /// Current session state
    var sessionState: SessionState = .unauthenticated

    /// Check if user is authenticated
    var isAuthenticated: Bool {
        sessionState == .authenticated && currentUser != nil
    }

    /// Get access token from keychain
    var accessToken: String? {
        keychain.get(.accessToken)
    }

    /// User role
    var role: UserRole {
        currentUser?.userRole ?? .user
    }

    /// The one in-flight refresh (restore, proactive and 401-driven refreshes all share it)
    private var refreshInFlight: Task<Void, Error>?

    init() {
        Task { await wireAPIClient() }
    }

    /// Wire token provider, refresh handler and session-over handler on APIClient
    private func wireAPIClient() async {
        await api.setAuthorizationProvider {
            KeychainService().get(.accessToken)
        }
        await api.setRefreshHandler { [weak self] in
            guard let self else { return .transient }
            return await self.refreshForAPI()
        }
        await api.setOnUnauthorized { [weak self] in
            await MainActor.run {
                self?.handleUnauthorized()
            }
        }
    }

    /// Session is over (refresh rejected) — sign out
    private func handleUnauthorized() {
        signOut()
    }

    /// Refresh on behalf of APIClient: only a rejected refresh token ends the session
    func refreshForAPI() async -> RefreshOutcome {
        do {
            try await refreshToken()
            return .refreshed
        } catch AuthError.refreshFailed {
            return .sessionOver
        } catch {
            return .transient
        }
    }

    // MARK: - Sign In Methods

    /// Sign in with an email or a login code (+ school subdomain for codes)
    /// Mirrors: POST /api/mobile/auth
    func signIn(identifier: String, password: String, school: String? = nil) async throws -> Session {
        let trimmedSchool = school?.trimmingCharacters(in: .whitespacesAndNewlines)
        let request = SignInRequest(
            identifier: identifier.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password,
            school: (trimmedSchool?.isEmpty ?? true) ? nil : trimmedSchool
        )

        do {
            let response: MobileAuthResponse = try await api.authRequest(
                "/mobile/auth", method: .post, body: request
            )
            let session = response.toSession()
            try saveSession(session)
            return session
        } catch {
            throw Self.mapAuthError(error)
        }
    }

    /// Map transport / server errors from the auth endpoints to `AuthError`
    nonisolated static func mapAuthError(_ error: Error) -> AuthError {
        if let authError = error as? AuthError { return authError }
        if let apiError = error as? APIError, case .http(let status, let code, let message) = apiError {
            switch status {
            case 400 where code == "SCHOOL_REQUIRED":
                return .schoolRequired
            case 401:
                if let message, message.localizedCaseInsensitiveContains("oauth") {
                    return .rejected(String(localized: "auth.error.socialOnly", defaultValue: "This account signs in with Google"))
                }
                return .rejected(String(localized: "auth.error.invalidLogin", defaultValue: "Invalid email or password"))
            case 403:
                return .suspended
            case 429:
                return .tooManyAttempts
            default:
                return .rejected(String(localized: "auth.error.generic", defaultValue: "Something went wrong"))
            }
        }
        if (error as NSError).domain == NSURLErrorDomain {
            return .offline
        }
        return .rejected(String(localized: "auth.error.generic", defaultValue: "Something went wrong"))
    }

    /// Sign in with Google
    /// Mirrors: signIn("google") in NextAuth
    func signInWithGoogle(idToken: String) async throws -> Session {
        let request = OAuthSignInRequest(provider: "google", token: idToken)
        let session = try await api.post("/auth/callback/google", body: request, as: Session.self)

        try saveSession(session)
        return session
    }

    /// Sign in with Facebook
    /// Mirrors: signIn("facebook") in NextAuth
    func signInWithFacebook(accessToken: String) async throws -> Session {
        let request = OAuthSignInRequest(provider: "facebook", token: accessToken)
        let session = try await api.post("/auth/callback/facebook", body: request, as: Session.self)

        try saveSession(session)
        return session
    }

    /// Sign in with Apple
    func signInWithApple(authorization: ASAuthorization) async throws -> Session {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            throw AuthError.invalidCredentials
        }

        let request = OAuthSignInRequest(provider: "apple", token: tokenString)
        let session = try await api.post("/auth/callback/apple", body: request, as: Session.self)

        try saveSession(session)
        return session
    }

    // MARK: - Session Management

    /// Save session to keychain
    private func saveSession(_ session: Session) throws {
        try keychain.save(session.accessToken, for: .accessToken)
        if let refreshToken = session.refreshToken {
            try keychain.save(refreshToken, for: .refreshToken)
        }
        if let data = try? JSONEncoder().encode(StoredSession(session: session)),
           let json = String(data: data, encoding: .utf8) {
            try? keychain.save(json, for: .sessionUser)
        }

        self.session = session
        self.currentUser = session.user
        self.sessionState = .authenticated
    }

    /// Rebuild the cached session from the keychain (no network)
    private func loadStoredSession() -> Session? {
        guard let token = keychain.get(.accessToken),
              let json = keychain.get(.sessionUser),
              let stored = try? JSONDecoder().decode(StoredSession.self, from: Data(json.utf8)) else {
            return nil
        }
        return Session(
            user: stored.user,
            schoolId: stored.schoolId ?? stored.user.schoolId,
            accessToken: token,
            refreshToken: keychain.get(.refreshToken),
            expiresAt: stored.expiresAt
        )
    }

    /// Restore session on app launch (offline-first)
    /// Uses the stored session + JWT `exp`; refreshes when expired / near expiry;
    /// signs out only when the refresh token is rejected (401/403).
    func restoreSession() async {
        let cached = loadStoredSession()

        if let cached {
            session = cached
            currentUser = cached.user
            sessionState = .authenticated
        }

        let payload = accessToken.flatMap { TokenPayload.decode(from: $0) }
        let needsRefresh = accessToken == nil || (payload.map { $0.isExpired || $0.shouldRefresh() } ?? false)

        if needsRefresh, keychain.get(.refreshToken) != nil {
            do {
                try await refreshToken()
            } catch AuthError.refreshFailed {
                signOut()
            } catch {
                // Offline / server trouble: keep the cached session
            }
        }

        if cached == nil && !(sessionState == .authenticated && currentUser != nil) {
            // Tokens without a cached user and no successful refresh: nothing to show
            signOut()
        }
    }

    /// Refresh the access token using the refresh token (serialized: one request at a time)
    /// Throws `AuthError.refreshFailed` only when the server rejects the refresh token.
    func refreshToken() async throws {
        if let running = refreshInFlight {
            return try await running.value
        }
        let task = Task { try await self.performRefresh() }
        refreshInFlight = task
        defer { refreshInFlight = nil }
        try await task.value
    }

    private func performRefresh() async throws {
        guard let refresh = keychain.get(.refreshToken) else {
            throw AuthError.refreshFailed
        }

        do {
            let response: MobileAuthResponse = try await api.authRequest(
                "/mobile/auth", method: .put, headers: ["X-Refresh-Token": refresh]
            )
            try saveSession(response.toSession())
        } catch let error as APIError {
            if case .http(let status, _, _) = error, status == 401 || status == 403 {
                throw AuthError.refreshFailed
            }
            throw AuthError.networkError(error)
        } catch {
            throw AuthError.networkError(error)
        }
    }

    /// Ensure token is fresh before an API call (proactive refresh)
    func ensureFreshToken() async {
        guard let token = accessToken,
              let payload = TokenPayload.decode(from: token),
              payload.shouldRefresh() else {
            return
        }

        try? await refreshToken()
    }

    /// Sign out — clear all auth state
    func signOut() {
        keychain.delete(.accessToken)
        keychain.delete(.refreshToken)
        keychain.delete(.sessionUser)
        currentUser = nil
        session = nil
        sessionState = .unauthenticated
    }
}

/// What survives a relaunch besides the tokens (tokens stay in their own keychain items)
struct StoredSession: Codable {
    let user: User
    let schoolId: String?
    let expiresAt: Date?

    init(session: Session) {
        user = session.user
        schoolId = session.schoolId
        expiresAt = session.expiresAt
    }
}
