import SwiftUI

// MARK: - HWDividerWithText
// Source: Figma iOS 26 — separator pattern
// Parity: kotlin-app/core/designsystem/atom/divider-with-text.kt

struct HWDividerWithText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(spacing: AppleSpacing.small) {
            Rectangle()
                .fill(Color.separatorVibrant)
                .frame(height: 1)

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .layoutPriority(1)

            Rectangle()
                .fill(Color.separatorVibrant)
                .frame(height: 1)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HWDividerWithText("or continue with")
        HWDividerWithText("OR")
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: 20) {
        HWDividerWithText("أو المتابعة عبر")
        HWDividerWithText("أو")
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
