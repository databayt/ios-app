import Foundation
import Testing
@testable import Hogwarts

/// Tests for the production mobile sign-in contract (POST/PUT /api/mobile/auth).
/// All fixtures are invented.
@Suite("Mobile Auth")
struct MobileAuthTests {

    // MARK: - needsSchool / normalizeSchool

    @Test("needsSchool: only non-empty identifiers without @", arguments: [
        ("teacher@example.com", false),
        ("  teacher@example.com  ", false),
        ("260001", true),
        ("jdoe", true),
        ("", false),
        ("   ", false),
    ])
    func needsSchool(identifier: String, expected: Bool) {
        #expect(AuthValidation.needsSchool(identifier) == expected)
    }

    @Test("normalizeSchool table", arguments: [
        ("myschool", "myschool"),
        ("MySchool", "myschool"),
        ("  MySchool  ", "myschool"),
        ("myschool.balqalam.com", "myschool"),
        ("https://myschool.balqalam.com/ar", "myschool"),
        ("http://myschool.balqalam.com", "myschool"),
        ("HTTPS://MySchool.Balqalam.com/ar/login", "myschool"),
        ("my-school", "my-school"),
        ("my school!", "myschool"),
        ("", ""),
        ("https://", ""),
    ])
    func normalizeSchool(raw: String, expected: String) {
        #expect(AuthValidation.normalizeSchool(raw) == expected)
    }

    @Test("Email needs no school; code with empty school fails validation")
    func schoolValidation() {
        #expect(AuthValidation.validateSchool(identifier: "a@b.com", school: "").isValid)
        #expect(!AuthValidation.validateSchool(identifier: "260001", school: "").isValid)
        #expect(!AuthValidation.validateSchool(identifier: "260001", school: "///").isValid)
        #expect(AuthValidation.validateSchool(identifier: "260001", school: "https://x.balqalam.com").isValid)
        #expect(!AuthValidation.validateIdentifier("  ").isValid)
    }

    @Test("initialSchool prefers stored, then plist, ignoring empty / unexpanded")
    func initialSchool() {
        #expect(AuthValidation.initialSchool(stored: "stored", plistDefault: "plist") == "stored")
        #expect(AuthValidation.initialSchool(stored: nil, plistDefault: "plist") == "plist")
        #expect(AuthValidation.initialSchool(stored: "", plistDefault: "plist") == "plist")
        #expect(AuthValidation.initialSchool(stored: nil, plistDefault: "$(HOGWARTS_DEFAULT_SCHOOL)") == "")
        #expect(AuthValidation.initialSchool(stored: nil, plistDefault: "") == "")
        #expect(AuthValidation.initialSchool(stored: nil, plistDefault: nil) == "")
    }

    // MARK: - Response decoding

    private let fixture = """
    {
      "access_token": "aaa.bbb.ccc",
      "refresh_token": "refresh-xyz",
      "expires_at": 1893456000000,
      "user": {
        "id": "u_1",
        "email": "teacher@example.test",
        "school_id": "sch_1",
        "role": "TEACHER",
        "given_name": "Sara",
        "family_name": "Example",
        "avatar_url": null,
        "grade": null
      }
    }
    """

    @Test("Decodes the mobile auth response and maps to Session")
    func decodesResponse() throws {
        let response = try JSONDecoder().decode(MobileAuthResponse.self, from: Data(fixture.utf8))
        #expect(response.accessToken == "aaa.bbb.ccc")
        #expect(response.refreshToken == "refresh-xyz")
        #expect(response.user.schoolId == "sch_1")

        let session = response.toSession()
        #expect(session.schoolId == "sch_1")
        #expect(session.user.name == "Sara Example")
        #expect(session.user.userRole == .teacher)
        #expect(session.expiresAt == Date(timeIntervalSince1970: 1_893_456_000))
        #expect(session.refreshToken == "refresh-xyz")
    }

    @Test("Decodes a login-code user with null email, empty names and numeric grade")
    func decodesCodeUser() throws {
        let json = """
        {"access_token":"a.b.c","refresh_token":"r","expires_at":1893456000000,
         "user":{"id":"u_2","email":null,"school_id":null,"role":"student",
                 "given_name":"","family_name":null,"avatar_url":null,"grade":7}}
        """
        let response = try JSONDecoder().decode(MobileAuthResponse.self, from: Data(json.utf8))
        let session = response.toSession()
        #expect(session.user.email == "")
        #expect(session.user.name == nil)
        #expect(session.user.userRole == .student)
        #expect(response.user.grade == "7")
    }

    @Test("SignInRequest omits school when nil and sends it when set")
    func requestEncoding() throws {
        let without = try JSONSerialization.jsonObject(
            with: JSONEncoder().encode(SignInRequest(identifier: "a@b.com", password: "pw"))
        ) as? [String: Any]
        #expect(without?["school"] == nil)
        #expect(without?["identifier"] as? String == "a@b.com")

        let with = try JSONSerialization.jsonObject(
            with: JSONEncoder().encode(SignInRequest(identifier: "260001", password: "pw", school: "myschool"))
        ) as? [String: Any]
        #expect(with?["school"] as? String == "myschool")
    }

    // MARK: - Roles

    @Test("Server roles normalize to UserRole", arguments: [
        ("TEACHER", UserRole.teacher), ("teacher", .teacher), (" Student ", .student),
        ("GUARDIAN", .guardian), ("ADMIN", .admin), ("DEVELOPER", .developer),
        ("ACCOUNTANT", .accountant), ("STAFF", .staff), ("USER", .user),
        ("SOMETHING_NEW", .user), ("", .user),
    ])
    func roles(raw: String, expected: UserRole) {
        #expect(UserRole(rawValue: RoleMapping.normalize(raw)) == expected)
    }

    @Test("nil role falls back to USER")
    func nilRole() {
        #expect(RoleMapping.normalize(nil) == "USER")
    }

    // MARK: - Errors

    @Test("Auth errors map from server codes")
    func errorMapping() {
        #expect(isCase(AuthManager.mapAuthError(APIError.http(status: 400, code: "SCHOOL_REQUIRED", message: "School required")), .schoolRequired))
        #expect(isCase(AuthManager.mapAuthError(APIError.http(status: 403, code: nil, message: "Account is suspended")), .suspended))
        #expect(isCase(AuthManager.mapAuthError(APIError.http(status: 429, code: "TOO_MANY_ATTEMPTS", message: nil)), .tooManyAttempts))
        #expect(isCase(AuthManager.mapAuthError(URLError(.notConnectedToInternet)), .offline))
        if case .rejected = AuthManager.mapAuthError(APIError.http(status: 401, code: nil, message: "Invalid email or password")) {} else {
            Issue.record("401 should map to .rejected")
        }
    }

    private func isCase(_ error: AuthError, _ expected: AuthError) -> Bool {
        switch (error, expected) {
        case (.schoolRequired, .schoolRequired), (.suspended, .suspended),
             (.tooManyAttempts, .tooManyAttempts), (.offline, .offline): return true
        default: return false
        }
    }

    // MARK: - Base URL

    @Test("Base URL falls back to production when missing, empty or unexpanded")
    func baseURLFallback() {
        let prod = "https://balqalam.com/api"
        #expect(APIConfig.resolveBaseURL(nil).absoluteString == prod)
        #expect(APIConfig.resolveBaseURL("").absoluteString == prod)
        #expect(APIConfig.resolveBaseURL("  ").absoluteString == prod)
        #expect(APIConfig.resolveBaseURL("$(HOGWARTS_API_BASE)").absoluteString == prod)
        #expect(APIConfig.resolveBaseURL("not a url").absoluteString == prod)
        #expect(APIConfig.resolveBaseURL(42).absoluteString == prod)
        #expect(APIConfig.resolveBaseURL("https://staging.example.test/api/").absoluteString == "https://staging.example.test/api")
    }

    @Test("URL joining handles leading slashes and query strings")
    func urlJoin() {
        let base = URL(string: "https://balqalam.com/api")!
        #expect(APIConfig.makeURL(base: base, path: "/mobile/auth").absoluteString == "https://balqalam.com/api/mobile/auth")
        #expect(APIConfig.makeURL(base: base, path: "mobile/auth").absoluteString == "https://balqalam.com/api/mobile/auth")
        #expect(APIConfig.makeURL(base: base, path: "/x?a=1").absoluteString == "https://balqalam.com/api/x?a=1")
        #expect(APIConfig.makeURL(base: base, path: "/x?a=1", query: ["b": "2"]).absoluteString == "https://balqalam.com/api/x?a=1&b=2")
        let slashBase = URL(string: "https://balqalam.com/api/")!
        #expect(APIConfig.makeURL(base: slashBase, path: "//y").absoluteString == "https://balqalam.com/api/y")
    }
}
