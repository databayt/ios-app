import SwiftUI

// MARK: - HWOfflineBanner
// Source: Figma iOS 26 — connectivity banner pattern
// Parity: kotlin-app/core/designsystem/atom/offline-banner.kt

struct HWOfflineBanner: View {
    let isOffline: Bool
    var message: String = "You're offline — showing cached data"

    var body: some View {
        if isOffline {
            HStack(spacing: AppleSpacing.compact) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 16))

                Text(message)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(Color.hogwartsError)
            .padding(.vertical, AppleSpacing.compact)
            .padding(.horizontal, AppleSpacing.standard)
            .frame(maxWidth: .infinity)
            .background(Color.hogwartsError.opacity(0.15))
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

#Preview("Offline Banner") {
    VStack(spacing: 0) {
        HWOfflineBanner(isOffline: true)

        VStack(spacing: AppleSpacing.standard) {
            Text("Page Content")
                .font(.title2.weight(.bold))
            Text("Content below the banner")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .animation(.easeInOut(duration: 0.3), value: true)
}

#Preview("RTL – Arabic") {
    VStack(spacing: 0) {
        HWOfflineBanner(
            isOffline: true,
            message: "أنت غير متصل — عرض البيانات المخزنة"
        )

        VStack(spacing: AppleSpacing.standard) {
            Text("محتوى الصفحة")
                .font(.title2.weight(.bold))
            Text("المحتوى أسفل الشريط")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
    .animation(.easeInOut(duration: 0.3), value: true)
}
