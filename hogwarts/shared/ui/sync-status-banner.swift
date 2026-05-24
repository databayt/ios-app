import SwiftUI
import SwiftData

/// Banner showing offline/sync status.
/// Shows when the device is offline OR when the last sync ended with an error.
struct SyncStatusBanner: View {
    private let networkMonitor = NetworkMonitor.shared
    private let sync = SyncEngine.shared

    var body: some View {
        Group {
            if !networkMonitor.isConnected {
                offlineBanner
            } else if sync.lastSyncError != nil {
                syncErrorBanner
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.snappy, value: networkMonitor.isConnected)
        .animation(.snappy, value: sync.lastSyncError != nil)
    }

    // MARK: - Subviews

    private var offlineBanner: some View {
        bannerShell(icon: "wifi.slash", label: String(localized: "sync.offline"), tint: .red) {
            if let lastSyncedAt = sync.lastSyncCompletedAt {
                Text(lastSyncedText(lastSyncedAt))
                    .font(.caption)
                    .opacity(0.8)
            }
        }
        .accessibilityLabel(String(localized: "a11y.sync.offlineBanner"))
    }

    private var syncErrorBanner: some View {
        bannerShell(
            icon: "exclamationmark.triangle.fill",
            label: String(localized: "sync.errorTitle"),
            tint: .orange,
            trailing: { EmptyView() }
        )
        .onTapGesture { Task { await sync.syncAll() } }
        .accessibilityLabel(String(localized: "a11y.sync.errorBanner"))
        .accessibilityHint(String(localized: "a11y.sync.errorBannerHint"))
    }

    // MARK: - Banner shell

    private func bannerShell<Trailing: View>(
        icon: String,
        label: String,
        tint: Color,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .accessibilityHidden(true)
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            trailing()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint.opacity(0.1))
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(tint.opacity(0.3), lineWidth: 1)
                }
        )
        .foregroundStyle(tint)
        .accessibilityElement(children: .combine)
    }

    private func lastSyncedText(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return String(localized: "sync.lastSynced \(formatter.localizedString(for: date, relativeTo: .now))")
    }
}
