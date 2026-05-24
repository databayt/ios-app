import SwiftUI
import UIKit

// MARK: - HWAppIcon
// Source: Figma iOS 26 — App Icon/iPhone (node 1:3538, 64×83)
// Parity: kotlin-app/core/designsystem/atom/app-icon.kt
//
// Rounded square 64pt, 14pt corner radius, with a 13pt SemiBold label below.
// Spacing matches Figma: 5pt gap, max width 76pt.
//
// Pass `fallbackBrush` for an iOS-26-style glossy gradient tile when no
// `iconName` (asset) or `systemImage` (SF Symbol) is provided.

/// One slot for `HWAppIconRow` and the home grid.
struct HWAppIconItem: Identifiable {
    let id = UUID()
    let label: String
    /// Asset catalog image name (e.g. `tile-stream`). Wins over `systemImage`.
    var iconName: String?
    /// SF Symbol fallback when `iconName` is not provided.
    var systemImage: String?
    /// Tint applied to gradient tile / SF Symbol fill.
    var tint: Color = .accentBlue
    /// Optional unread / count badge — rendered by `HWBadgedAppIcon`.
    var badgeCount: Int = 0
    var action: (() -> Void)?
}

struct HWAppIcon: View {
    let label: String
    var iconName: String?
    var systemImage: String?
    var tint: Color = .accentBlue
    var labelColor: Color = .white
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 5) {
                tile
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(labelColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 76)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(label))
            .accessibilityAddTraits(.isButton)
        }
        .buttonStyle(.plain)
        // Disable haptics + selection chrome that .plain still bubbles up
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var tile: some View {
        ZStack {
            if let iconName, UIImage(named: iconName) != nil {
                // Full-bleed Figma-authored tile art (color + glyph baked in)
                Image(iconName)
                    .resizable()
                    .scaledToFill()
            } else {
                // iOS-26 glossy gradient fallback with optional SF Symbol glyph
                Self.glossBrush(tint: tint)
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.20), radius: 4, x: 0, y: 2)
    }

    /// Vertical gradient: lifted top → saturated mid → shaded bottom.
    /// Mirrors `iosTileBrush` in the Kotlin atom.
    static func glossBrush(tint: Color) -> some View {
        LinearGradient(
            colors: [
                tint.lerp(to: .white, t: 0.22),
                tint,
                tint.lerp(to: .black, t: 0.08)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - HWAppIconRow

struct HWAppIconRow: View {
    let items: [HWAppIconItem]
    var labelColor: Color = .white

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(items) { item in
                    HWAppIcon(
                        label: item.label,
                        iconName: item.iconName,
                        systemImage: item.systemImage,
                        tint: item.tint,
                        labelColor: labelColor,
                        action: item.action
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Color blending helper

private extension Color {
    /// Blend two colors in sRGB. `t` clamps to [0,1].
    func lerp(to other: Color, t: CGFloat) -> Color {
        let clamp = max(0, min(1, t))
        let a = UIColor(self)
        let b = UIColor(other)
        var ar: CGFloat = 0, ag: CGFloat = 0, ab: CGFloat = 0, aa: CGFloat = 0
        var br: CGFloat = 0, bg: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0
        a.getRed(&ar, green: &ag, blue: &ab, alpha: &aa)
        b.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
        return Color(
            red: Double(ar + (br - ar) * clamp),
            green: Double(ag + (bg - ag) * clamp),
            blue: Double(ab + (bb - ab) * clamp),
            opacity: Double(aa + (ba - aa) * clamp)
        )
    }
}

#Preview("LTR — gradient fallback") {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 14) {
            HWAppIcon(label: "Students", systemImage: "person.2.fill", tint: .accentBlue)
            HWAppIcon(label: "Attendance", systemImage: "checkmark.circle.fill", tint: .accentGreen)
            HWAppIcon(label: "Grades", systemImage: "chart.bar.fill", tint: .accentOrange)
        }
    }
}

#Preview("RTL — Arabic") {
    ZStack {
        Color.black.ignoresSafeArea()
        HWAppIconRow(items: [
            HWAppIconItem(label: "الطلاب", systemImage: "person.2.fill", tint: .accentBlue),
            HWAppIconItem(label: "الحضور", systemImage: "checkmark.circle.fill", tint: .accentGreen),
            HWAppIconItem(label: "الدرجات", systemImage: "chart.bar.fill", tint: .accentOrange)
        ])
    }
    .environment(\.layoutDirection, .rightToLeft)
}
