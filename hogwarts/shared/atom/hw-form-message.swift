import SwiftUI

// MARK: - HWFormMessage
// Source: Figma iOS 26 — form validation message pattern
// Parity: kotlin-app/core/designsystem/atom/form-error.kt + form-success.kt

enum HWFormMessageVariant {
    case error
    case success

    var backgroundColor: Color {
        switch self {
        case .error: .formErrorBackground
        case .success: .formSuccessBackground
        }
    }

    var foregroundColor: Color {
        switch self {
        case .error: .formErrorForeground
        case .success: .formSuccessForeground
        }
    }

    var icon: String {
        switch self {
        case .error: "exclamationmark.triangle.fill"
        case .success: "checkmark.circle.fill"
        }
    }
}

struct HWFormMessage: View {
    let message: String
    var variant: HWFormMessageVariant = .error

    var body: some View {
        HStack(spacing: AppleSpacing.compact) {
            Image(systemName: variant.icon)
                .font(.system(size: 16))

            Text(message)
                .font(.footnote)

            Spacer(minLength: 0)
        }
        .foregroundStyle(variant.foregroundColor)
        .padding(AppleSpacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            variant.backgroundColor,
            in: RoundedRectangle(cornerRadius: 6, style: .continuous)
        )
    }
}

#Preview("Form Messages") {
    VStack(spacing: AppleSpacing.small) {
        HWFormMessage(message: "Invalid email or password")
        HWFormMessage(message: "Email address is required")
        HWFormMessage(
            message: "Account created successfully",
            variant: .success
        )
        HWFormMessage(
            message: "Password updated",
            variant: .success
        )
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: AppleSpacing.small) {
        HWFormMessage(message: "البريد الإلكتروني أو كلمة المرور غير صالحة")
        HWFormMessage(message: "البريد الإلكتروني مطلوب")
        HWFormMessage(
            message: "تم إنشاء الحساب بنجاح",
            variant: .success
        )
        HWFormMessage(
            message: "تم تحديث كلمة المرور",
            variant: .success
        )
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
