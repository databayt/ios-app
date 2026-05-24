import SwiftUI

// MARK: - HWBadgedAppIcon
// Source: Figma iOS 26 — Notification Badge anchored to App Icon top-trailing
// Parity: kotlin-app/core/designsystem/atom/badged-app-icon.kt
//
// `HWAppIcon` + iOS-style red numeric pill anchored to the top-trailing corner
// (auto-mirrors to top-leading in RTL because we use logical edges). The badge
// is suppressed when `count <= 0` so callers can pass unread counts directly.

struct HWBadgedAppIcon: View {
    let label: String
    var iconName: String?
    var systemImage: String?
    var tint: Color = .accentBlue
    var labelColor: Color = .white
    let count: Int
    var action: (() -> Void)?

    var body: some View {
        HWAppIcon(
            label: label,
            iconName: iconName,
            systemImage: systemImage,
            tint: tint,
            labelColor: labelColor,
            action: action
        )
        .overlay(alignment: .topTrailing) {
            if count > 0 {
                badgeText
                    .accessibilityHidden(true)
                    // Pull the badge slightly outside the 64pt tile, matching
                    // Material3 BadgedBox offsets in the Kotlin atom (2,-4).
                    .offset(x: 6, y: -8)
                    // Anchor to the tile's top-trailing — labelMaxWidth is 76,
                    // so we constrain the overlay box to the 64pt tile width.
                    .padding(.trailing, 6)
            }
        }
        // Build a single combined a11y label so VoiceOver reads
        // "Messages, 3 unread" instead of two separate elements.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(combinedAccessibilityLabel))
        .accessibilityAddTraits(.isButton)
    }

    private var displayCount: String {
        count > 99 ? "99+" : "\(count)"
    }

    private var badgeText: some View {
        Text(displayCount)
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, count > 9 ? 6 : 0)
            .frame(minWidth: 22, minHeight: 22)
            .background(Color.accentRed, in: Capsule())
            .overlay(Capsule().strokeBorder(.white.opacity(0.18), lineWidth: 0.5))
    }

    private var combinedAccessibilityLabel: String {
        guard count > 0 else { return label }
        // Localized plural via String Catalog: the `badge.unreadCount` key
        // supports Arabic's six plural categories (one/two/few/many/other).
        let unread = String(localized: "badge.unreadCount \(count)")
        return "\(label), \(unread)"
    }
}

#Preview("Badged — counts") {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 14) {
            HWBadgedAppIcon(
                label: "Messages",
                systemImage: "bubble.left.and.bubble.right.fill",
                tint: .accentGreen,
                count: 3
            )
            HWBadgedAppIcon(
                label: "Notifications",
                systemImage: "bell.fill",
                tint: .accentRed,
                count: 128
            )
            HWBadgedAppIcon(
                label: "Settings",
                systemImage: "gearshape.fill",
                tint: .appleGray1,
                count: 0
            )
        }
    }
}

#Preview("Badged — RTL") {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 14) {
            HWBadgedAppIcon(
                label: "الرسائل",
                systemImage: "bubble.left.and.bubble.right.fill",
                tint: .accentGreen,
                count: 3
            )
            HWBadgedAppIcon(
                label: "الإشعارات",
                systemImage: "bell.fill",
                tint: .accentRed,
                count: 12
            )
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
