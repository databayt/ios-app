import Foundation

/// Server actions for the password-reset flow.
///
/// Three-step protocol:
///   1. `requestReset(email:)` — POST /mobile/auth/reset
///   2. `verifyOtp(email:otp:)` — POST /mobile/auth/verify-otp
///   3. `setNewPassword(email:otp:password:)` — POST /mobile/auth/new-password
///
/// The backend always returns 200 from `/reset` to prevent email
/// enumeration; `/verify-otp` and `/new-password` return 401 for bad codes.
final class AuthResetActions: Sendable {
    private let api = APIClient.shared

    private struct ResetBody: Encodable { let email: String }
    private struct VerifyBody: Encodable {
        let email: String
        let otp: String
    }
    private struct NewPasswordBody: Encodable {
        let email: String
        let otp: String
        let newPassword: String
    }

    @discardableResult
    func requestReset(email: String) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/auth/reset",
            body: ResetBody(email: email),
            as: EmptyResponse.self
        )
    }

    @discardableResult
    func verifyOtp(email: String, otp: String) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/auth/verify-otp",
            body: VerifyBody(email: email, otp: otp),
            as: EmptyResponse.self
        )
    }

    @discardableResult
    func setNewPassword(email: String, otp: String, newPassword: String) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/auth/new-password",
            body: NewPasswordBody(email: email, otp: otp, newPassword: newPassword),
            as: EmptyResponse.self
        )
    }
}
