import SwiftUI

// MARK: - HWSectionHeader
// Source: Figma iOS 26 — Header (node 17:3294)
// Parity: kotlin-app/core/designsystem/atom/section-header.kt

struct HWSectionHeader: View {
    let title: String
    var action: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Spacer()

            if let action, let onAction {
                Button(action, action: onAction)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal, AppleSpacing.standard)
        .padding(.vertical, AppleSpacing.compact)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 0) {
        HWSectionHeader(title: "Students")
        HWSectionHeader(title: "Attendance", action: "See All") {}
    }
    .background(Color.groupedBackground)
}

#Preview("RTL – Arabic") {
    VStack(alignment: .leading, spacing: 0) {
        HWSectionHeader(title: "الطلاب")
        HWSectionHeader(title: "الحضور", action: "عرض الكل") {}
    }
    .background(Color.groupedBackground)
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
