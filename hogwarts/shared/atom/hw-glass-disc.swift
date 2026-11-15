import SwiftUI

// MARK: - HWGlassDisc
// A round control on a video stage: an iOS material disc, an SF Symbol, an optional fill
// (state: muted, raised, sharing) and an optional count badge.
// Parity: android-app live room control row (48dp glass circles); web room `control-bar.tsx` discs.

struct HWGlassDisc: View {
    let systemImage: String
    let accessibilityLabel: LocalizedStringKey
    var fill: Color? = nil
    var glyph: Color = .white
    var badge: String? = nil
    var size: CGFloat = 48
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                if let fill {
                    Circle().fill(fill)
                }
                Image(systemName: systemImage)
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(glyph)
            }
            .frame(width: size, height: size)
            .overlay(alignment: .topTrailing) {
                if let badge {
                    Text(badge)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 6)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(Color(red: 0.984, green: 0.749, blue: 0.141), in: Capsule())
                        .offset(x: 4, y: -4)
                }
            }
            .opacity(isDisabled ? 0.5 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview("Glass disc") {
    HStack(spacing: 10) {
        HWGlassDisc(systemImage: "video", accessibilityLabel: "Camera") {}
        HWGlassDisc(systemImage: "mic.slash", accessibilityLabel: "Microphone",
                    fill: Color(red: 0.86, green: 0.15, blue: 0.15).opacity(0.85)) {}
        HWGlassDisc(systemImage: "hand.raised", accessibilityLabel: "Hands", badge: "3") {}
    }
    .padding(32)
    .background(.black)
}

#Preview("RTL – Arabic") {
    HStack(spacing: 10) {
        HWGlassDisc(systemImage: "video", accessibilityLabel: "الكاميرا") {}
        HWGlassDisc(systemImage: "mic.slash", accessibilityLabel: "الميكروفون",
                    fill: Color(red: 0.86, green: 0.15, blue: 0.15).opacity(0.85)) {}
        HWGlassDisc(systemImage: "bubble.left", accessibilityLabel: "الدردشة", badge: "٢") {}
    }
    .padding(32)
    .background(.black)
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
