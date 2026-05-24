import SwiftUI

struct IosFilterChip: View {
    enum State { case `default`, active }
    let label: String?
    let state: State
    let isIconOnly: Bool
    let onTap: () -> Void

    @Environment(\.whatsAppColors) private var wa

    init(label: String, state: State = .default, onTap: @escaping () -> Void) {
        self.label = label
        self.state = state
        self.isIconOnly = false
        self.onTap = onTap
    }

    init(icon onTap: @escaping () -> Void) {
        self.label = nil
        self.state = .default
        self.isIconOnly = true
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            Group {
                if isIconOnly {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(wa.textCtaFilters)
                        .frame(width: 34, height: 34)
                } else if let label {
                    Text(label)
                        .font(.system(size: 14, weight: .semibold))
                        .tracking(-0.14)
                        .foregroundStyle(state == .active ? wa.textCtaFiltersActive : wa.textCtaFilters)
                        .padding(.horizontal, 14)
                        .frame(height: 34)
                }
            }
            .background(state == .active ? wa.surfaceCtaFiltersActive : wa.surfaceCtaFilters)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
