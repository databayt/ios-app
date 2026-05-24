import SwiftUI

struct IosChatRowData: Identifiable {
    let id: String
    let name: String
    let avatarUrl: String?
    let avatarFallback: String
    let isGroup: Bool
    let online: Bool
    let preview: String
    let previewLeading: IosPreviewLeading?
    let previewItalic: Bool
    let timestamp: String
    let unreadCount: Int
    let mentioned: Bool
    let pinned: Bool
    let muted: Bool
}

struct IosChatRow: View {
    let row: IosChatRowData
    let onTap: (() -> Void)?
    @Environment(\.whatsAppColors) private var wa

    init(row: IosChatRowData, onTap: (() -> Void)? = nil) {
        self.row = row
        self.onTap = onTap
    }

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(alignment: .top, spacing: 12.66) {
                avatar
                    .frame(width: 56, height: 56)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 8) {
                        VStack(alignment: .leading, spacing: 1.5) {
                            Text(row.name)
                                .font(.system(size: 16, weight: .semibold))
                                .tracking(-0.32)
                                .foregroundStyle(wa.textPrimary)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            IosMessagePreview(
                                text: row.preview,
                                leading: row.previewLeading,
                                italic: row.previewItalic
                            )
                        }

                        VStack(alignment: .trailing, spacing: 3) {
                            Text(row.timestamp)
                                .font(.system(size: 14))
                                .tracking(-0.14)
                                .foregroundStyle(row.unreadCount > 0 ? wa.textProduct : wa.textSecondary)
                                .lineLimit(1)
                                .padding(.top, 1)

                            badges
                        }
                        .frame(width: 60)
                    }
                    .frame(height: 67.33)
                    .padding(.trailing, 15)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(wa.borderSeparator)
                            .frame(height: 0.33)
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var avatar: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if row.isGroup {
                    LinearGradient(
                        colors: [Color(white: 0.70), Color(white: 0.52)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 22, weight: .regular))
                    }
                } else if let url = URL(string: row.avatarUrl ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        fallbackCircle
                    }
                } else {
                    fallbackCircle
                }
            }
            .clipShape(Circle())
            .overlay(
                Circle().stroke(wa.borderAvatar, lineWidth: 0.33)
            )

            IosPresenceDot(online: row.online)
        }
    }

    private var fallbackCircle: some View {
        ZStack {
            Circle().fill(wa.textSecondary.opacity(0.9))
            Text(row.avatarFallback)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    private var badges: some View {
        HStack(spacing: 6) {
            if row.mentioned {
                Text("@")
                    .font(.system(size: 17, weight: .semibold).italic())
                    .tracking(-0.17)
                    .foregroundStyle(wa.textProduct)
                    .frame(minWidth: 16)
            }
            if row.unreadCount > 0 {
                Text("\(row.unreadCount)")
                    .font(.system(size: 12))
                    .tracking(-0.12)
                    .foregroundStyle(wa.textInvert)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .frame(minHeight: 18)
                    .background(wa.surfaceProduct)
                    .clipShape(Capsule())
            } else if row.pinned {
                Image(systemName: "pin.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(wa.textSecondary)
                    .rotationEffect(.degrees(45))
                    .frame(width: 16, height: 16)
            }
        }
        .frame(height: 16)
    }
}
