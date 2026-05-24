import SwiftUI

// MARK: - HWCard
// Source: Figma iOS 26 — Liquid Glass (nodes 16:3092, 16:3105)
// Parity: kotlin-app/core/designsystem/atom/glass-card.kt

enum HWCardStyle {
    case glass       // Liquid glass material
    case solid       // Solid white/dark surface
    case clear       // Transparent glass
}

struct HWCard<Content: View>: View {
    let style: HWCardStyle
    let padding: CGFloat
    @ViewBuilder let content: Content

    init(
        style: HWCardStyle = .solid,
        padding: CGFloat = AppleSpacing.standard,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        Group {
            content
                .padding(padding)
        }
        .modifier(CardStyleModifier(style: style))
    }
}

private struct CardStyleModifier: ViewModifier {
    let style: HWCardStyle

    func body(content: Content) -> some View {
        switch style {
        case .glass:
            content
                .liquidGlassCard(cornerRadius: HWShape.card)

        case .solid:
            content
                .background(
                    Color(uiColor: .secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: HWShape.card, style: .continuous)
                )
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)

        case .clear:
            content
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: HWShape.card, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: HWShape.card, style: .continuous)
                        .strokeBorder(.quaternary.opacity(0.3), lineWidth: 0.5)
                }
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        }
    }
}

#Preview("Card Styles") {
    ScrollView {
        VStack(spacing: 20) {
            HWCard(style: .solid) {
                VStack(alignment: .leading) {
                    Text("Solid Card").font(.headline)
                    Text("Standard white surface").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HWCard(style: .glass) {
                VStack(alignment: .leading) {
                    Text("Glass Card").font(.headline)
                    Text("Frosted glass material").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HWCard(style: .clear) {
                VStack(alignment: .leading) {
                    Text("Clear Card").font(.headline)
                    Text("Ultra-thin transparent").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    .background(Color.groupedBackground)
}

#Preview("RTL – Arabic") {
    ScrollView {
        VStack(spacing: 20) {
            HWCard(style: .solid) {
                VStack(alignment: .leading) {
                    Text("بطاقة صلبة").font(.headline)
                    Text("سطح أبيض قياسي").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HWCard(style: .glass) {
                VStack(alignment: .leading) {
                    Text("بطاقة زجاجية").font(.headline)
                    Text("زجاج بلوري شفاف").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HWCard(style: .clear) {
                VStack(alignment: .leading) {
                    Text("بطاقة شفافة").font(.headline)
                    Text("شفافية فائقة الرقة").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    .background(Color.groupedBackground)
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
