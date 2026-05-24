import SwiftUI

// MARK: - HWSocialButton
// Source: Figma iOS 26 — social auth pattern
// Parity: kotlin-app/core/designsystem/atom/social-button.kt

struct HWSocialButton: View {
    let title: String
    let icon: Image
    var iconColor: Color? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppleSpacing.compact) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(iconColor ?? .primary)

                Text(title)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.separatorVibrant, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - HWSocialAuthButtons

struct HWSocialAuthButtons: View {
    let onGoogleTap: () -> Void
    let onAppleTap: () -> Void

    var body: some View {
        HStack(spacing: AppleSpacing.small) {
            HWSocialButton(
                title: "Google",
                icon: googleIcon,
                action: onGoogleTap
            )

            HWSocialButton(
                title: "Apple",
                icon: Image(systemName: "apple.logo"),
                action: onAppleTap
            )
        }
    }

    private var googleIcon: Image {
        // SF Symbols has no Google icon — use styled text placeholder
        // In production, replace with asset catalog image
        Image(systemName: "g.circle.fill")
    }
}

#Preview("Social Buttons") {
    VStack(spacing: AppleSpacing.standard) {
        HWSocialButton(
            title: "Continue with Google",
            icon: Image(systemName: "g.circle.fill"),
            action: {}
        )
        HWSocialButton(
            title: "Continue with Apple",
            icon: Image(systemName: "apple.logo"),
            action: {}
        )
        HWSocialAuthButtons(onGoogleTap: {}, onAppleTap: {})
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: AppleSpacing.standard) {
        HWSocialButton(
            title: "المتابعة مع جوجل",
            icon: Image(systemName: "g.circle.fill"),
            action: {}
        )
        HWSocialButton(
            title: "المتابعة مع آبل",
            icon: Image(systemName: "apple.logo"),
            action: {}
        )
        HWSocialAuthButtons(onGoogleTap: {}, onAppleTap: {})
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
