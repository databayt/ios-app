import SwiftUI

enum WaFilterId: String, CaseIterable, Identifiable {
    case all, unread, favourites, groups
    var id: String { rawValue }
}

struct IosFilterChips: View {
    let active: WaFilterId
    let labels: [WaFilterId: String]
    let onChange: (WaFilterId) -> Void
    let onAdd: (() -> Void)?

    init(
        active: WaFilterId,
        labels: [WaFilterId: String] = [
            .all: "All",
            .unread: "Unread",
            .favourites: "Favourites",
            .groups: "Groups",
        ],
        onChange: @escaping (WaFilterId) -> Void,
        onAdd: (() -> Void)? = nil
    ) {
        self.active = active
        self.labels = labels
        self.onChange = onChange
        self.onAdd = onAdd
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(WaFilterId.allCases) { id in
                IosFilterChip(
                    label: labels[id] ?? id.rawValue.capitalized,
                    state: id == active ? .active : .default,
                    onTap: { onChange(id) }
                )
            }
            if let onAdd {
                IosFilterChip(icon: onAdd)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
