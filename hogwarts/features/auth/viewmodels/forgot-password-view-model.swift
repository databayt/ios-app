import Foundation
import SwiftUI

// MARK: - ForgotPasswordViewModel
//
// Three-step state machine: email entry → OTP entry → new password.
// Each step posts to its endpoint, then advances `step` on success.

@MainActor
@Observable
final class ForgotPasswordViewModel {
    enum Step: Hashable {
        case email
        case otp
        case newPassword
        case done
    }

    private(set) var step: Step = .email
    private(set) var isLoading = false
    private(set) var lastError: String?

    var email: String = ""
    var otp: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""

    private let actions: AuthResetActions

    init(actions: AuthResetActions = .init()) {
        self.actions = actions
    }

    // MARK: - Validation

    var canRequestReset: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        return trimmed.contains("@") && trimmed.contains(".")
    }

    var canVerifyOtp: Bool {
        // Backend uses 6-digit OTPs; trim whitespace just in case the user pastes.
        otp.trimmingCharacters(in: .whitespaces).count >= 4
    }

    var canSetPassword: Bool {
        newPassword.count >= 8 && newPassword == confirmPassword
    }

    var passwordMismatch: Bool {
        !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword != confirmPassword
    }

    // MARK: - Steps

    func requestReset() async {
        guard canRequestReset else { return }
        await run {
            try await self.actions.requestReset(email: self.email)
            self.step = .otp
        }
    }

    func verifyOtp() async {
        guard canVerifyOtp else { return }
        await run {
            try await self.actions.verifyOtp(email: self.email, otp: self.otp)
            self.step = .newPassword
        }
    }

    func setNewPassword() async {
        guard canSetPassword else { return }
        await run {
            try await self.actions.setNewPassword(
                email: self.email,
                otp: self.otp,
                newPassword: self.newPassword
            )
            self.step = .done
        }
    }

    /// Resend the OTP — re-issues `/reset` and stays on the OTP step.
    func resendOtp() async {
        await run {
            try await self.actions.requestReset(email: self.email)
        }
    }

    // MARK: - Helpers

    private func run(_ op: @escaping () async throws -> Void) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            try await op()
        } catch is CancellationError {
            // ignore
        } catch let error as APIError {
            switch error {
            case .unauthorized, .validationFailed:
                lastError = String(localized: "forgotPassword.error.invalidCode")
            default:
                lastError = error.localizedDescription
            }
        } catch {
            lastError = error.localizedDescription
        }
    }
}
