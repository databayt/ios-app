import Foundation
import Testing
@testable import Hogwarts

@Suite("ForgotPasswordViewModel")
@MainActor
struct ForgotPasswordViewModelTests {

    @Test("canRequestReset accepts valid email")
    func canRequestResetValid() {
        let vm = ForgotPasswordViewModel()
        vm.email = "user@example.com"
        #expect(vm.canRequestReset)
    }

    @Test("canRequestReset rejects malformed email", arguments: ["", "user", "user@example", "user.example.com"])
    func canRequestResetInvalid(_ input: String) {
        let vm = ForgotPasswordViewModel()
        vm.email = input
        #expect(!vm.canRequestReset)
    }

    @Test("canVerifyOtp requires 4+ digits")
    func canVerifyOtp() {
        let vm = ForgotPasswordViewModel()
        vm.otp = "1234"
        #expect(vm.canVerifyOtp)
        vm.otp = "12"
        #expect(!vm.canVerifyOtp)
        vm.otp = "  654321  "
        #expect(vm.canVerifyOtp)  // trims whitespace
    }

    @Test("canSetPassword requires min length and match")
    func canSetPassword() {
        let vm = ForgotPasswordViewModel()
        vm.newPassword = "short"
        vm.confirmPassword = "short"
        #expect(!vm.canSetPassword)  // too short
        vm.newPassword = "LongEnough123"
        vm.confirmPassword = "LongEnough123"
        #expect(vm.canSetPassword)
        vm.confirmPassword = "Different"
        #expect(!vm.canSetPassword)  // mismatch
    }

    @Test("passwordMismatch flag is precise")
    func passwordMismatchFlag() {
        let vm = ForgotPasswordViewModel()
        // Both empty → no mismatch yet (don't nag user).
        #expect(!vm.passwordMismatch)
        vm.newPassword = "abc12345"
        #expect(!vm.passwordMismatch)  // confirm still empty
        vm.confirmPassword = "abc12345"
        #expect(!vm.passwordMismatch)
        vm.confirmPassword = "different"
        #expect(vm.passwordMismatch)
    }
}
