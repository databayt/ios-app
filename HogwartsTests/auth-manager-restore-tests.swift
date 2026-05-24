import Foundation
import Testing
@testable import Hogwarts

/// Tests for the new `AuthManager.restoreSession` flow:
///   1. Valid JWT → install stub → fetch `/mobile/profile` → upgrade
///   2. Valid JWT → fetch fails → keep stub (do NOT sign out)
///   3. No token in keychain → unauthenticated, no network call
///   4. Malformed JWT → sign out
///
/// Uses an in-memory keychain + the same `MockAPIClient` as the
/// SyncEngine tests, proving the protocol seams work end-to-end.
@Suite("AuthManager.restoreSession")
@MainActor
struct AuthManagerRestoreTests {

    @Test("Installs stub then upgrades to real /me profile")
    func upgradesToRealProfile() async {
        let keychain = InMemoryKeychain()
        try? keychain.save(makeJWT(), for: .accessToken)

        let api = MockAPIClient()
        api.stubProfile(.fixture(name: "Real Name", phone: "+966500000000"))

        let auth = AuthManager(keychain: keychain, api: api)
        await auth.restoreSession()

        #expect(auth.isAuthenticated)
        #expect(auth.currentUser?.name == "Real Name", "should be upgraded from JWT stub")
        #expect(auth.currentUser?.phone == "+966500000000", "JWT-only stub never had phone")
    }

    @Test("Keeps the JWT stub if /me fails — does NOT sign out")
    func keepsStubOnProfileFailure() async {
        let keychain = InMemoryKeychain()
        try? keychain.save(makeJWT(name: "Stub Name"), for: .accessToken)

        let api = MockAPIClient()
        api.stubFailure(for: "/mobile/profile", error: URLError(.notConnectedToInternet))

        let auth = AuthManager(keychain: keychain, api: api)
        await auth.restoreSession()

        #expect(auth.isAuthenticated, "stub keeps the session usable while offline")
        #expect(auth.currentUser?.name == "Stub Name")
        #expect(auth.currentUser?.phone == nil, "JWT carries no phone — stub stays as-is")
    }

    @Test("No access token → unauthenticated, no network call")
    func noTokenDoesNothing() async {
        let keychain = InMemoryKeychain()
        let api = MockAPIClient()

        let auth = AuthManager(keychain: keychain, api: api)
        await auth.restoreSession()

        #expect(!auth.isAuthenticated)
        #expect(auth.currentUser == nil)
        #expect(api.calls.isEmpty)
    }

    @Test("Malformed JWT signs out cleanly")
    func malformedJWTSignsOut() async {
        let keychain = InMemoryKeychain()
        try? keychain.save("not.a.jwt.at.all", for: .accessToken)

        let api = MockAPIClient()
        let auth = AuthManager(keychain: keychain, api: api)
        await auth.restoreSession()

        #expect(!auth.isAuthenticated)
        #expect(keychain.get(.accessToken) == nil, "signOut wipes tokens")
    }

    // MARK: - Helpers

    /// Build a minimal JWT (header.payload.signature) with the claims our
    /// `TokenPayload.decode` expects. The signature is junk — we never
    /// verify it client-side, the server does.
    private func makeJWT(
        sub: String = "user-1",
        email: String = "stub@test.com",
        name: String = "Stub Name",
        role: String = "STUDENT",
        schoolId: String = "school-1",
        expiresIn seconds: TimeInterval = 3600
    ) -> String {
        let header  = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}"
        let claims: [String: Any] = [
            "sub": sub,
            "exp": Date().addingTimeInterval(seconds).timeIntervalSince1970,
            "email": email,
            "name": name,
            "role": role,
            "schoolId": schoolId
        ]
        let payloadData = try! JSONSerialization.data(withJSONObject: claims)
        return [
            base64URL(header.data(using: .utf8)!),
            base64URL(payloadData),
            "sig"
        ].joined(separator: ".")
    }

    private func base64URL(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))
    }
}

// MARK: - In-memory keychain

/// Implements `KeychainServicing` over a plain dictionary so tests don't
/// touch the real Keychain (which is process-wide and survives between
/// test runs — a recipe for flake).
final class InMemoryKeychain: KeychainServicing, @unchecked Sendable {
    private let lock = NSLock()
    private var store: [KeychainService.Key: String] = [:]

    func save(_ value: String, for key: KeychainService.Key) throws {
        lock.withLock { store[key] = value }
    }
    func get(_ key: KeychainService.Key) -> String? {
        lock.withLock { store[key] }
    }
    func delete(_ key: KeychainService.Key) {
        lock.withLock { _ = store.removeValue(forKey: key) }
    }
    func clearAll() {
        lock.withLock { store.removeAll() }
    }
}

// MARK: - User fixture + profile stub

private extension User {
    static func fixture(
        id: String = "user-1",
        email: String = "real@test.com",
        name: String = "Real Name",
        phone: String? = nil
    ) -> User {
        User(
            id: id,
            email: email,
            name: name,
            nameAr: nil,
            role: "STUDENT",
            schoolId: "school-1",
            imageUrl: nil,
            phone: phone,
            emailVerified: nil,
            isTwoFactorEnabled: false,
            createdAt: nil,
            updatedAt: nil
        )
    }
}

private extension MockAPIClient {
    /// Stub the `/mobile/profile` endpoint with a fully-formed `User`.
    /// Encoded with snake_case so `APIClient`'s decoder strategy round-trips.
    func stubProfile(_ user: User) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = (try? encoder.encode(user)) ?? Data()
        // Re-use the public `stubFailure` interface as the existing `stubs`
        // dictionary lives behind `stubEmpty` / `stubFailure` only — extend
        // through the success path by directly calling `stubEmpty`-like behavior.
        // The mock's internal `stubs` dict is private, so install a stub by
        // routing through an overload added in the mock file. For now, use
        // the existing `stubEmpty` to install a 200 response with our payload.
        installSuccess(for: "/mobile/profile", payload: data)
    }
}
