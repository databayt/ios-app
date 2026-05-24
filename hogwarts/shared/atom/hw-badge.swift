import SwiftUI

// MARK: - HWBadge
// Source: Figma iOS 26 — status badge pattern
// Parity: kotlin-app/core/designsystem/atom/status-badge.kt

enum HWBadgeVariant {
    case `default`
    case success
    case warning
    case error
    case info

    var backgroundColor: Color {
        switch self {
        case .default: .fillTertiary
        case .success: .statusSuccess.opacity(0.15)
        case .warning: .statusWarning.opacity(0.15)
        case .error: .statusError.opacity(0.15)
        case .info: .statusInfo.opacity(0.15)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .default: .primary
        case .success: .statusSuccess
        case .warning: .statusWarning
        case .error: .statusError
        case .info: .statusInfo
        }
    }
}

struct HWBadge: View {
    let text: String
    var variant: HWBadgeVariant = .default
    var icon: String? = nil

    var body: some View {
        HStack(spacing: AppleSpacing.tiny) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption2)
            }
            Text(text)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(variant.foregroundColor)
        .padding(.horizontal, AppleSpacing.compact)
        .padding(.vertical, AppleSpacing.tiny)
        .background(
            variant.backgroundColor,
            in: Capsule()
        )
    }
}

#Preview("Badge Variants") {
    HStack(spacing: 8) {
        HWBadge(text: "Default")
        HWBadge(text: "Present", variant: .success, icon: "checkmark")
        HWBadge(text: "Late", variant: .warning, icon: "clock")
        HWBadge(text: "Absent", variant: .error, icon: "xmark")
        HWBadge(text: "Info", variant: .info, icon: "info.circle")
    }
    .padding()
}

#Preview("RTL – Arabic") {
    HStack(spacing: 8) {
        HWBadge(text: "نشط")
        HWBadge(text: "حاضر", variant: .success, icon: "checkmark")
        HWBadge(text: "تحذير", variant: .warning, icon: "clock")
        HWBadge(text: "غائب", variant: .error, icon: "xmark")
        HWBadge(text: "معلومات", variant: .info, icon: "info.circle")
    }
    .padding()
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
