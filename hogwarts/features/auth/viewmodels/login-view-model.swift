import SwiftUI

/// ViewModel for login form
/// Manages form state, validation, loading, and error handling
@Observable
@MainActor
final class LoginViewModel {
    static let schoolDefaultsKey = "login_school"

    /// Email, or a login code / username
    var identifier = ""
    var school: String
    var password = ""
    var isLoading = false
    var error: Error?
    var showError = false

    /// Field-level validation (shown after first submit attempt)
    var identifierError: String?
    var schoolError: String?
    var passwordError: String?
    var hasAttemptedSubmit = false

    private let defaults: UserDefaults

    init(
        defaults: UserDefaults = .standard,
        plistDefaultSchool: Any? = Bundle.main.object(forInfoDictionaryKey: "HWDefaultSchool")
    ) {
        self.defaults = defaults
        self.school = AuthValidation.initialSchool(
            stored: defaults.string(forKey: Self.schoolDefaultsKey),
            plistDefault: plistDefaultSchool
        )
    }

    /// The school field only shows for login codes / usernames
    var showsSchoolField: Bool {
        AuthValidation.needsSchool(identifier)
    }

    /// Whether the form can be submitted
    var canSubmit: Bool {
        !isLoading && !identifier.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    /// Validate fields and update error messages
    func validate() -> Bool {
        let id = AuthValidation.validateIdentifier(identifier)
        let sch = AuthValidation.validateSchool(identifier: identifier, school: school)
        let pw = AuthValidation.validatePassword(password)
        identifierError = id.errorMessage
        schoolError = sch.errorMessage
        passwordError = pw.errorMessage
        hasAttemptedSubmit = true
        return id.isValid && sch.isValid && pw.isValid
    }

    /// Sign in with email or login code
    func login(authManager: AuthManager, tenantContext: TenantContext) async {
        guard validate() else { return }

        isLoading = true
        defer { isLoading = false }

        let needsSchool = showsSchoolField
        let normalized = AuthValidation.normalizeSchool(school)

        do {
            let session = try await authManager.signIn(
                identifier: identifier,
                password: password,
                school: needsSchool ? normalized : nil
            )
            if needsSchool {
                defaults.set(normalized, forKey: Self.schoolDefaultsKey)
            }
            if let schoolId = session.schoolId {
                tenantContext.setTenant(schoolId: schoolId)
            }
        } catch AuthError.schoolRequired {
            schoolError = AuthError.schoolRequired.errorDescription
            password = ""
        } catch {
            self.error = error
            showError = true
            password = ""
        }
    }

    /// Clear validation errors on field edit
    func onIdentifierChanged() {
        if hasAttemptedSubmit {
            identifierError = AuthValidation.validateIdentifier(identifier).errorMessage
            schoolError = AuthValidation.validateSchool(identifier: identifier, school: school).errorMessage
        }
    }

    func onSchoolChanged() {
        if hasAttemptedSubmit {
            schoolError = AuthValidation.validateSchool(identifier: identifier, school: school).errorMessage
        }
    }

    func onPasswordChanged() {
        if hasAttemptedSubmit {
            passwordError = AuthValidation.validatePassword(password).errorMessage
        }
    }
}
