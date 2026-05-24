import SwiftUI

// MARK: - HWFilterChips
// Source: Figma iOS 26 — filter chip pattern
// Parity: kotlin-app/core/designsystem/atom/filter-chips-row.kt

struct HWFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, AppleSpacing.small)
                .padding(.vertical, AppleSpacing.compact)
                .background(
                    isSelected ? Color.accentBlue : Color.fillTertiary,
                    in: Capsule()
                )
        }
        .animation(.spring(duration: 0.25), value: isSelected)
    }
}

struct HWFilterChips<Item: Hashable>: View {
    let items: [Item]
    @Binding var selected: Item?
    let title: (Item) -> String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppleSpacing.compact) {
                ForEach(items, id: \.self) { item in
                    HWFilterChip(
                        title: title(item),
                        isSelected: selected == item
                    ) {
                        selected = selected == item ? nil : item
                    }
                }
            }
            .padding(.horizontal, AppleSpacing.standard)
        }
    }
}

#Preview {
    @Previewable @State var selected: String? = "All"

    VStack(spacing: 20) {
        HWFilterChips(
            items: ["All", "Present", "Absent", "Late"],
            selected: $selected
        ) { $0 }
    }
}

#Preview("RTL – Arabic") {
    @Previewable @State var selected: String? = "الكل"

    VStack(spacing: 20) {
        HWFilterChips(
            items: ["الكل", "حاضر", "غائب", "متأخر"],
            selected: $selected
        ) { $0 }
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
