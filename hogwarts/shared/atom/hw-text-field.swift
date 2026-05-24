import SwiftUI

// MARK: - HWTextField
// Source: Figma iOS 26 — Text Field Row (node 7:2112)
// Parity: kotlin-app/core/designsystem/atom/hogwarts-text-field.kt

struct HWTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var error: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil

    @State private var isSecureVisible = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: AppleSpacing.tiny) {
            // Label
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Input field
            HStack(spacing: AppleSpacing.compact) {
                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                            .textContentType(textContentType)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .textContentType(textContentType)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .sentences)
                    }
                }
                .focused($isFocused)
                .submitLabel(submitLabel)
                .onSubmit { onSubmit?() }

                if isSecure {
                    Button {
                        isSecureVisible.toggle()
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, AppleSpacing.small)
            .padding(.vertical, AppleSpacing.small)
            .background(
                Color.fillTertiary,
                in: RoundedRectangle(cornerRadius: HWShape.textField, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: HWShape.textField, style: .continuous)
                    .strokeBorder(
                        error != nil ? Color.hogwartsError :
                            isFocused ? Color.hogwartsPrimary : .clear,
                        lineWidth: 1
                    )
            }

            // Error message
            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(Color.formErrorForeground)
                    .padding(.horizontal, AppleSpacing.tiny)
            }
        }
    }
}

#Preview("Text Fields") {
    VStack(spacing: 20) {
        HWTextField(
            label: "Email",
            text: .constant("user@example.com"),
            placeholder: "Enter email",
            keyboardType: .emailAddress,
            textContentType: .emailAddress
        )

        HWTextField(
            label: "Password",
            text: .constant(""),
            placeholder: "Enter password",
            isSecure: true,
            textContentType: .password
        )

        HWTextField(
            label: "With Error",
            text: .constant("bad"),
            placeholder: "Enter value",
            error: "This field is required"
        )
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: 20) {
        HWTextField(
            label: "البريد الإلكتروني",
            text: .constant("user@example.com"),
            placeholder: "أدخل بريدك",
            keyboardType: .emailAddress,
            textContentType: .emailAddress
        )

        HWTextField(
            label: "كلمة المرور",
            text: .constant(""),
            placeholder: "أدخل كلمة المرور",
            isSecure: true,
            textContentType: .password
        )

        HWTextField(
            label: "مع خطأ",
            text: .constant("خطأ"),
            placeholder: "أدخل القيمة",
            error: "هذا الحقل مطلوب"
        )
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
