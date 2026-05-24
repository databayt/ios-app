import SwiftUI
import UIKit

// MARK: - HomeDock
// Source: Figma iOS 26 — Dock (node 112:609 — 402×140 outer, 368×103 pill)
// Parity: kotlin-app/feature/dashboard/.../home-dock.kt
//
// iOS home-screen glass dock with 4 fixed slots. Specs:
//   • Outer margins: 17pt horizontal, 20pt top, 17pt bottom
//   • Pill: 38pt continuous corner radius, ultraThinMaterial backdrop
//   • Hairline white border for the lit-edge highlight
//   • 64pt icon tiles with 14pt continuous corner radius
//
// SwiftUI's `.ultraThinMaterial` plus a vertical white-overlay gradient
// approximates the Figma `mix-blend-screen`/`hard-light` compositing that
// CoreGraphics doesn't expose directly.

struct HomeDockItem: Identifiable {
    let id = UUID()
    /// SF Symbol shown when no asset is provided.
    let systemImage: String
    /// Optional full-bleed asset (e.g. `tile-message`).
    var assetName: String?
    /// Gradient tint applied to the asset-less fallback.
    let tint: Color
    /// Localized accessibility label — VoiceOver reads this.
    let accessibilityLabel: LocalizedStringResource
    let action: () -> Void
}

struct HomeDock: View {
    let items: [HomeDockItem]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                DockTile(item: item)
                if item.id != items.last?.id {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 19)
        .padding(.top, 20)
        .padding(.bottom, 19)
        .background {
            ZStack {
                // Liquid-glass backdrop — uses iOS 18+ system material.
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .fill(.ultraThinMaterial)
                // Lit-top → soft-bottom highlight gradient
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.45),
                                .white.opacity(0.18),
                                .white.opacity(0.22)
                            ],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .blendMode(.plusLighter)
                // Hairline edge
                RoundedRectangle(cornerRadius: 38, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.55), .white.opacity(0.12)],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: 0.5
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
        .shadow(color: .black.opacity(0.22), radius: 24, x: 0, y: 12)
        .padding(.horizontal, 17)
        .padding(.top, 20)
        .padding(.bottom, 17)
    }
}

private struct DockTile: View {
    let item: HomeDockItem

    var body: some View {
        Button {
            item.action()
        } label: {
            ZStack {
                if let assetName = item.assetName, UIImage(named: assetName) != nil {
                    Image(assetName)
                        .resizable()
                        .scaledToFill()
                } else {
                    HWAppIcon.glossBrush(tint: item.tint)
                    Image(systemName: item.systemImage)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.30), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(item.accessibilityLabel))
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Dock — light over wallpaper") {
    ZStack {
        LinearGradient(
            colors: [.accentBlue.opacity(0.7), .accentPurple.opacity(0.6)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack {
            Spacer()
            HomeDock(items: [
                HomeDockItem(systemImage: "house.fill", tint: .accentBlue,
                             accessibilityLabel: "tab.dashboard", action: {}),
                HomeDockItem(systemImage: "bubble.left.and.bubble.right.fill",
                             tint: .accentGreen,
                             accessibilityLabel: "tab.messages", action: {}),
                HomeDockItem(systemImage: "bell.fill", tint: .accentRed,
                             accessibilityLabel: "tab.notifications", action: {}),
                HomeDockItem(systemImage: "gearshape.fill", tint: .appleGray1,
                             accessibilityLabel: "tab.profile", action: {})
            ])
        }
    }
}
