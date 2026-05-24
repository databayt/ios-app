import SwiftUI

struct IosArchivedRow: View {
    let label: String
    let count: Int?
    let onTap: (() -> Void)?
    @Environment(\.whatsAppColors) private var wa

    init(label: String = "Archived", count: Int? = nil, onTap: (() -> Void)? = nil) {
        self.label = label
        self.count = count
        self.onTap = onTap
    }

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(alignment: .top, spacing: 28.66) {
                Image(systemName: "archivebox")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 24, height: 24)
                    .foregroundStyle(wa.textSecondary)

                HStack(alignment: .top) {
                    Text(label)
                        .font(.system(size: 16, weight: .semibold))
                        .tracking(-0.32)
                        .foregroundStyle(wa.textPrimary)
                    Spacer()
                    if let count, count > 0 {
                        Text("\(count)")
                            .font(.system(size: 14))
                            .foregroundStyle(wa.textSecondary)
                    }
                }
                .padding(.bottom, 12)
                .padding(.trailing, 15)
                .padding(.top, 2.5)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(wa.borderSeparator)
                        .frame(height: 0.33)
                }
            }
            .padding(.leading, 32)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
