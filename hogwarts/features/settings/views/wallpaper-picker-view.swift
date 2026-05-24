import SwiftUI

struct WallpaperPickerView: View {
    @Binding var selectedId: String
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(WallpaperCatalog.options) { option in
                        WallpaperCell(option: option, selected: option.id == selectedId)
                            .onTapGesture {
                                selectedId = option.id
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle("settings.wallpaper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("settings.cancel") { dismiss() }
                }
            }
        }
    }
}

private struct WallpaperCell: View {
    let option: WallpaperOption
    let selected: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(option.assetName)
                .resizable()
                .aspectRatio(9.0 / 16.0, contentMode: .fill)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 60)

            Text(option.label)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(8)

            if selected {
                Rectangle().strokeBorder(Color.accentColor, lineWidth: 3)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.accentColor)
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
    }
}
