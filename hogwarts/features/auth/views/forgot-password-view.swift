import SwiftUI

// MARK: - ForgotPasswordView
//
// Single screen that swaps body content based on `viewModel.step`. Each
// step has a single primary action; the back button cancels the flow
// (handled by parent NavigationStack). On success the final step shows
// a "you can sign in now" panel and dismisses on tap.

struct ForgotPasswordView: View {
    @State private var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case email, otp, newPassword, confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                content
                if let error = viewModel.lastError {
                    errorBanner(error)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(Text("forgotPassword.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: viewModel.step == .done ? "checkmark.seal.fill" : "lock.rotation")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(viewModel.step == .done ? .green : .accentColor)
            Text(stepHeading)
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            Text(stepSubheading)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }

    private var stepHeading: LocalizedStringResource {
        switch viewModel.step {
        case .email:       "forgotPassword.email.title"
        case .otp:         "forgotPassword.otp.title"
        case .newPassword: "forgotPassword.newPassword.title"
        case .done:        "forgotPassword.done.title"
        }
    }

    private var stepSubheading: LocalizedStringResource {
        switch viewModel.step {
        case .email:       "forgotPassword.email.subtitle"
        case .otp:         "forgotPassword.otp.subtitle"
        case .newPassword: "forgotPassword.newPassword.subtitle"
        case .done:        "forgotPassword.done.subtitle"
        }
    }

    // MARK: - Content per step

    @ViewBuilder
    private var content: some View {
        switch viewModel.step {
        case .email:       emailStep
        case .otp:         otpStep
        case .newPassword: newPasswordStep
        case .done:        doneStep
        }
    }

    private var emailStep: some View {
        VStack(spacing: 14) {
            TextField(String(localized: "login.email"), text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .onSubmit { Task { await viewModel.requestReset() } }
                .accessibilityLabel(String(localized: "a11y.login.email"))

            primaryButton(title: "forgotPassword.email.action",
                          enabled: viewModel.canRequestReset) {
                Task { await viewModel.requestReset() }
            }
        }
        .onAppear { focusedField = .email }
    }

    private var otpStep: some View {
        VStack(spacing: 14) {
            TextField(String(localized: "forgotPassword.otp.placeholder"), text: $viewModel.otp)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($focusedField, equals: .otp)
                .accessibilityLabel(String(localized: "forgotPassword.otp.title"))

            primaryButton(title: "forgotPassword.otp.action",
                          enabled: viewModel.canVerifyOtp) {
                Task { await viewModel.verifyOtp() }
            }

            Button {
                Task { await viewModel.resendOtp() }
            } label: {
                Text("forgotPassword.otp.resend")
                    .font(.subheadline)
                    .foregroundStyle(.tint)
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .onAppear { focusedField = .otp }
    }

    private var newPasswordStep: some View {
        VStack(spacing: 14) {
            SecureField(String(localized: "forgotPassword.newPassword.placeholder"), text: $viewModel.newPassword)
                .textFieldStyle(.roundedBorder)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .newPassword)
                .accessibilityLabel(String(localized: "forgotPassword.newPassword.placeholder"))

            SecureField(String(localized: "forgotPassword.confirm.placeholder"), text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .confirmPassword)
                .accessibilityLabel(String(localized: "forgotPassword.confirm.placeholder"))

            if viewModel.passwordMismatch {
                Label(String(localized: "forgotPassword.error.mismatch"), systemImage: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            primaryButton(title: "forgotPassword.newPassword.action",
                          enabled: viewModel.canSetPassword) {
                Task { await viewModel.setNewPassword() }
            }
        }
        .onAppear { focusedField = .newPassword }
    }

    private var doneStep: some View {
        VStack(spacing: 14) {
            Button(String(localized: "forgotPassword.done.action")) {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Helpers

    private func primaryButton(title: LocalizedStringResource, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(enabled ? Color.accentColor : Color.accentColor.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(!enabled || viewModel.isLoading)
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color.orange.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview("LTR") { NavigationStack { ForgotPasswordView() } }
#Preview("RTL") {
    NavigationStack { ForgotPasswordView() }
        .environment(\.layoutDirection, .rightToLeft)
}
