import SwiftUI
import AuthenticationServices

/// Authentication manager
/// Mirrors: src/auth.ts + src/auth.config.ts
@Observable
@MainActor
final class AuthManager {
    private let keychain: KeychainServicing
    private let api: APIClientProtocol
    private let profile: ProfileActions

    /// Default-arg init: production code is unchanged (`AuthManager()`),
    /// tests can inject a `MockAPIClient` + an in-memory keychain to drive
    /// `restoreSession`, refresh, and sign-in/out flows deterministically.
    init(
        keychain: KeychainServicing = KeychainService(),
        api: APIClientProtocol = APIClient.shared,
        profile: ProfileActions? = nil
    ) {
        self.keychain = keychain
        self.api = api
        self.profile = profile ?? ProfileActions(api: api)
        Task { await wireAPIClient() }
    }

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

    /// Wire both callbacks on `APIClient`:
    ///   - 401 → sign out
    ///   - auth header → always read the current access token so a refresh
    ///     issued mid-flight is picked up on the next request without the
    ///     client having to round-trip through the keychain.
    private func wireAPIClient() async {
        await api.setOnUnauthorized { [weak self] in
            await MainActor.run { self?.handleUnauthorized() }
        }
        await api.setAuthorizationProvider { [weak self] in
            // `self` is @MainActor — reading `accessToken` from a nonisolated
            // `@Sendable` closure is safe because it just delegates to the
            // keychain, which is thread-safe.
            self?.keychain.get(.accessToken)
        }
    }

    /// Handle 401 response — sign out immediately
    private func handleUnauthorized() {
        signOut()
    }

    // MARK: - Sign In Methods

    /// Sign in with email/password
    /// Mirrors: signIn("credentials") in NextAuth
    func signIn(email: String, password: String) async throws -> Session {
        let request = SignInRequest(email: email, password: password)

        let session = try await api.post("/mobile/auth", body: request, as: Session.self)

        try saveSession(session)
        return session
    }

    /// Sign in with Google
    /// Mirrors: signIn("google") in NextAuth
    func signInWithGoogle(idToken: String) async throws -> Session {
        let request = GoogleSignInRequest(idToken: idToken)
        let session = try await api.post("/mobile/auth/google", body: request, as: Session.self)

        try saveSession(session)
        return session
    }

    /// Sign in with Facebook
    /// Mirrors: signIn("facebook") in NextAuth
    func signInWithFacebook(accessToken: String) async throws -> Session {
        let request = FacebookSignInRequest(accessToken: accessToken)
        let session = try await api.post("/mobile/auth/facebook", body: request, as: Session.self)

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

        let givenName = credential.fullName?.givenName
        let familyName = credential.fullName?.familyName
        let authCode: String? = credential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }

        let request = AppleSignInRequest(
            identityToken: tokenString,
            authorizationCode: authCode,
            givenName: givenName,
            familyName: familyName
        )
        let session = try await api.post("/mobile/auth/apple", body: request, as: Session.self)

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

        self.session = session
        self.currentUser = session.user
        self.sessionState = .authenticated
    }

    /// Restore session on app launch.
    /// Steps:
    ///   1. Validate cached JWT — sign out if missing or malformed.
    ///   2. Refresh if expired or near expiry.
    ///   3. Fetch the real profile from `/mobile/profile` so cached data
    ///      like `nameAr`, `phone`, `imageUrl` is hydrated. Falls back to
    ///      a JWT-derived stub so the app still works offline on cold launch.
    func restoreSession() async {
        guard let token = accessToken else {
            sessionState = .unauthenticated
            return
        }

        guard let payload = TokenPayload.decode(from: token) else {
            signOut()
            return
        }

        if payload.isExpired {
            do {
                try await refreshToken()
            } catch {
                signOut()
                return
            }
            // refreshToken() rewrote keychain + currentUser via saveSession.
            await hydrateProfile(schoolIdFallback: payload.schoolId)
            return
        }

        if payload.shouldRefresh() {
            try? await refreshToken()
        }

        // Stop-gap: install the JWT stub so `isAuthenticated` flips immediately
        // and the UI can render. The network fetch below upgrades it in place.
        installStub(from: payload, token: token)
        await hydrateProfile(schoolIdFallback: payload.schoolId)
    }

    /// Pull the canonical `User` from the API. Silent on failure: the
    /// stub session installed by `installStub` keeps the app usable when
    /// offline, and the next foreground / pull-to-refresh tries again.
    private func hydrateProfile(schoolIdFallback: String?) async {
        let token = accessToken
        guard let schoolId = session?.schoolId ?? schoolIdFallback else { return }
        do {
            let user = try await profile.getProfile(schoolId: schoolId)
            self.currentUser = user
            // Keep tokens; only replace the user on a successful fetch.
            if let token {
                self.session = Session(
                    user: user,
                    schoolId: schoolId,
                    accessToken: token,
                    refreshToken: keychain.get(.refreshToken),
                    expiresAt: session?.expiresAt
                )
            }
        } catch {
            // Offline or transient — keep the stub session, don't sign out.
        }
    }

    /// Materialize a minimal `User` from JWT claims so the UI doesn't
    /// flash login while the real profile is being fetched.
    private func installStub(from payload: TokenPayload, token: String) {
        let stub = User(
            id: payload.sub,
            email: payload.email ?? "",
            name: payload.name ?? payload.email ?? "",
            nameAr: nil,
            role: payload.role ?? "student",
            schoolId: payload.schoolId ?? "",
            imageUrl: nil,
            phone: nil,
            emailVerified: .now,
            isTwoFactorEnabled: false,
            createdAt: .now,
            updatedAt: .now
        )
        let stubSession = Session(
            user: stub,
            schoolId: payload.schoolId,
            accessToken: token,
            refreshToken: keychain.get(.refreshToken),
            expiresAt: payload.exp
        )
        self.session = stubSession
        self.currentUser = stub
        self.sessionState = .authenticated
    }

    /// Refresh the access token using the refresh token
    /// Web API expects PUT /mobile/auth with X-Refresh-Token header
    func refreshToken() async throws {
        guard let refresh = keychain.get(.refreshToken) else {
            throw AuthError.refreshFailed
        }

        do {
            let session = try await api.refreshAuth(refreshToken: refresh)
            try saveSession(session)
        } catch {
            throw AuthError.refreshFailed
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
        currentUser = nil
        session = nil
        sessionState = .unauthenticated
    }
}
