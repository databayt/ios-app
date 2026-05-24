import SwiftUI

struct IosTitleBlock: View {
    let title: String
    let searchPlaceholder: String
    @Binding var searchText: String
    let activeFilter: WaFilterId
    let filterLabels: [WaFilterId: String]
    let onFilterChange: (WaFilterId) -> Void
    let onAddFilter: (() -> Void)?

    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 33.33, weight: .bold))
                .tracking(-1.3332)
                .foregroundStyle(wa.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 1) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(wa.textSecondary)
                    .frame(width: 24, height: 24)

                TextField(searchPlaceholder, text: $searchText)
                    .font(.system(size: 16.4))
                    .foregroundStyle(wa.textPrimary)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
            }
            .padding(5)
            .background(wa.surfaceSearchChat)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.bottom, 8)

            IosFilterChips(
                active: activeFilter,
                labels: filterLabels,
                onChange: onFilterChange,
                onAdd: onAddFilter
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 5)
        .padding(.bottom, 8)
    }
}
