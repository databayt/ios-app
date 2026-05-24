import SwiftUI

enum IosTabId: String, Identifiable {
    case calls, classes, chats, back
    var id: String { rawValue }
}

struct IosTab: Identifiable {
    let id: IosTabId
    let label: String
    let systemImage: String
    let badge: Int?
}

struct IosTabbar: View {
    let tabs: [IosTab]
    let active: IosTabId
    let onChange: (IosTabId) -> Void

    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                ForEach(tabs) { tab in
                    tabButton(tab)
                }
            }
            .padding(.top, 3)
            .padding(.bottom, 2)
            .padding(.horizontal, 23)

            IosHomeIndicator()
        }
        .background(
            wa.surfacePanelBlur
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) {
            Rectangle().fill(wa.borderPanel).frame(height: 0.33)
        }
    }

    @ViewBuilder
    private func tabButton(_ tab: IosTab) -> some View {
        let isActive = tab.id == active
        let color = isActive ? wa.textTabbarSelected : wa.textTabbar

        Button(action: { onChange(tab.id) }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 2) {
                    Image(systemName: tab.systemImage)
                        .font(.system(size: 24, weight: isActive ? .bold : .regular))
                        .frame(width: 32, height: 32)
                        .foregroundStyle(color)
                    Text(tab.label)
                        .font(.system(size: 10, weight: .medium))
                        .tracking(0.05)
                        .foregroundStyle(color)
                }

                if let badge = tab.badge, badge > 0 {
                    Text("\(badge)")
                        .font(.system(size: 12))
                        .tracking(-0.12)
                        .foregroundStyle(wa.textInvert)
                        .padding(.horizontal, 6)
                        .frame(minWidth: 18, minHeight: 18)
                        .background(wa.surfaceProduct)
                        .clipShape(Capsule())
                        .offset(x: 13, y: 0)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isActive ? .isSelected : [])
        .frame(maxWidth: .infinity)
    }
}
