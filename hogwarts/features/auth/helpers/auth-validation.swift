import Foundation

/// Client-side validation for auth forms
/// Mirrors: src/components/auth/validation.ts
struct AuthValidation {

    /// Validate email format
    static func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .invalid(String(localized: "validation.required"))
        }

        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(email.startIndex..., in: email)
        let match = regex?.firstMatch(in: email, range: range)

        if match == nil {
            return .invalid(String(localized: "auth.error.invalidEmail"))
        }

        return .valid
    }

    /// Validate password is not empty
    static func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .invalid(String(localized: "auth.error.emptyPassword"))
        }
        return .valid
    }

    // MARK: - Email or login code + school (mirrors Android login-view-model companion)

    /// A login code or username, not an email: the server needs the school to resolve it.
    static func needsSchool(_ identifier: String) -> Bool {
        let id = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        return !id.isEmpty && !id.contains("@")
    }

    /// "myschool", "myschool.balqalam.com" or "https://myschool.balqalam.com/ar" -> "myschool".
    static func normalizeSchool(_ raw: String) -> String {
        var value = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for prefix in ["https://", "http://"] where value.hasPrefix(prefix) {
            value.removeFirst(prefix.count)
            break
        }
        value = String(value.prefix { $0 != "/" })
        value = String(value.prefix { $0 != "." })
        return String(value.unicodeScalars.filter {
            ("a"..."z").contains(Character($0)) || ("0"..."9").contains(Character($0)) || $0 == "-"
        })
    }

    /// First field: an email, or a login code / username.
    static func validateIdentifier(_ identifier: String) -> ValidationResult {
        identifier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .invalid(String(localized: "auth.error.identifierRequired", defaultValue: "Email or login code is required"))
            : .valid
    }

    /// School is required only when the identifier is not an email.
    static func validateSchool(identifier: String, school: String) -> ValidationResult {
        if needsSchool(identifier) && normalizeSchool(school).isEmpty {
            return .invalid(String(localized: "auth.error.schoolRequired", defaultValue: "Enter your school's name"))
        }
        return .valid
    }

    /// School to prefill: the last one used, else the build's default (ignores empty / unexpanded values).
    static func initialSchool(stored: String?, plistDefault: Any?) -> String {
        if let stored, !stored.isEmpty { return stored }
        if let value = (plistDefault as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
           !value.isEmpty, !value.contains("$(") {
            return value
        }
        return ""
    }

    /// Validate login form fields
    static func validateLoginForm(email: String, password: String) -> LoginFormValidation {
        let emailResult = validateEmail(email)
        let passwordResult = validatePassword(password)
        return LoginFormValidation(
            email: emailResult,
            password: passwordResult
        )
    }
}

// MARK: - Types

/// Reuses ValidationResult from students-validation.swift (shared type)

struct LoginFormValidation {
    let email: ValidationResult
    let password: ValidationResult

    var isValid: Bool {
        email.isValid && password.isValid
    }
}
