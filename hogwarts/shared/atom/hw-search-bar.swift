import SwiftUI

// MARK: - HWSearchBar
// Source: Figma iOS 26 — search pattern
// Parity: kotlin-app/core/designsystem/atom/search-bar.kt

struct HWSearchBar: View {
    @Binding var text: String
    var placeholder: String = String(localized: "common.search")
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppleSpacing.compact) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.body)

            TextField(placeholder, text: $text)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, AppleSpacing.small)
        .padding(.vertical, AppleSpacing.compact)
        .background(
            Color.fillTertiary,
            in: Capsule()
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        HWSearchBar(text: .constant(""))
        HWSearchBar(text: .constant("Students"))
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: 16) {
        HWSearchBar(text: .constant(""), placeholder: "بحث...")
        HWSearchBar(text: .constant("طلاب"), placeholder: "بحث...")
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
