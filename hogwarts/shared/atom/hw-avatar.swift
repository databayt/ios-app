import SwiftUI

// MARK: - HWAvatar
// Source: Figma iOS 26 — avatar pattern
// Parity: kotlin-app/core/designsystem/atom/user-avatar.kt

enum HWAvatarSize {
    case small
    case medium
    case large

    var dimension: CGFloat {
        switch self {
        case .small: 32
        case .medium: 40
        case .large: 56
        }
    }

    var font: Font {
        switch self {
        case .small: .caption2.weight(.semibold)
        case .medium: .callout.weight(.semibold)
        case .large: .title3.weight(.semibold)
        }
    }
}

struct HWAvatar: View {
    let name: String
    var imageURL: URL? = nil
    var size: HWAvatarSize = .medium

    private var initials: String {
        name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
    }

    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        initialsView
                    default:
                        Color.fillTertiary
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: size.dimension, height: size.dimension)
        .clipShape(Circle())
    }

    private var initialsView: some View {
        ZStack {
            Color.hogwartsPrimary.opacity(0.15)
            Text(initials)
                .font(size.font)
                .foregroundStyle(Color.hogwartsPrimary)
        }
    }
}

#Preview("Avatar Sizes") {
    HStack(spacing: AppleSpacing.standard) {
        HWAvatar(name: "John Doe", size: .small)
        HWAvatar(name: "Jane Smith", size: .medium)
        HWAvatar(name: "Ahmed Ali", size: .large)
    }
    .padding()
}

#Preview("RTL – Arabic") {
    HStack(spacing: AppleSpacing.standard) {
        HWAvatar(name: "محمد أحمد", size: .small)
        HWAvatar(name: "فاطمة علي", size: .medium)
        HWAvatar(name: "عبدالله خالد", size: .large)
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
