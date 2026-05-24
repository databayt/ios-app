import SwiftUI

// MARK: - HWButton
// Source: Figma iOS 26 — Action Sheet (node 1:58)
// Parity: kotlin-app/core/designsystem/atom/hogwarts-button.kt

enum HWButtonVariant {
    case `default`    // Blue filled
    case secondary    // Gray filled
    case outline      // Bordered, no fill
    case ghost        // No background
    case destructive  // Red filled
    case link         // Text only, blue
}

enum HWButtonSize {
    case sm, md, lg

    var verticalPadding: CGFloat {
        switch self {
        case .sm: 8
        case .md: 12
        case .lg: 16
        }
    }

    var font: Font {
        switch self {
        case .sm: .subheadline.weight(.medium)
        case .md: .body.weight(.medium)
        case .lg: .body.weight(.semibold)
        }
    }
}

struct HWButton: View {
    let title: String
    let variant: HWButtonVariant
    let size: HWButtonSize
    let isLoading: Bool
    let isFullWidth: Bool
    let action: () -> Void

    init(
        _ title: String,
        variant: HWButtonVariant = .default,
        size: HWButtonSize = .md,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                } else {
                    Text(title)
                }
            }
            .font(size.font)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, AppleSpacing.standard)
            .background(backgroundColor, in: buttonShape)
            .overlay {
                if variant == .outline {
                    buttonShape.strokeBorder(Color.hogwartsPrimary, lineWidth: 1.5)
                }
            }
        }
        .disabled(isLoading)
    }

    private var buttonShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: HWShape.button, style: .continuous)
    }

    private var backgroundColor: Color {
        switch variant {
        case .default: .hogwartsPrimary
        case .secondary: .fillTertiary
        case .outline: .clear
        case .ghost: .clear
        case .destructive: .hogwartsError
        case .link: .clear
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .default: .white
        case .secondary: .primary
        case .outline: .hogwartsPrimary
        case .ghost: .hogwartsPrimary
        case .destructive: .white
        case .link: .hogwartsPrimary
        }
    }
}

#Preview("All Variants") {
    VStack(spacing: 12) {
        HWButton("Default Button") {}
        HWButton("Secondary", variant: .secondary) {}
        HWButton("Outline", variant: .outline) {}
        HWButton("Ghost", variant: .ghost) {}
        HWButton("Destructive", variant: .destructive) {}
        HWButton("Link", variant: .link, isFullWidth: false) {}
        HWButton("Loading...", isLoading: true) {}
    }
    .padding()
}

#Preview("RTL – Arabic") {
    VStack(spacing: 12) {
        HWButton("تسجيل الدخول") {}
        HWButton("إرسال", variant: .secondary) {}
        HWButton("تأكيد", variant: .outline) {}
        HWButton("تخطي", variant: .ghost) {}
        HWButton("حذف", variant: .destructive) {}
        HWButton("إلغاء", variant: .link, isFullWidth: false) {}
        HWButton("جاري التحميل...", isLoading: true) {}
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
