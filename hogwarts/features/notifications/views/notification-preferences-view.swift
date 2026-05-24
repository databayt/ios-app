import SwiftUI

// MARK: - NotificationPreferencesView
//
// One section per category. Inside each section, one toggle per channel
// (Push / In-App / Email / SMS). Switching a toggle optimistically updates
// the local state and PUTs the change immediately — saving indicator in
// the toolbar gives feedback while the request flies.

struct NotificationPreferencesView: View {
    @State private var viewModel = NotificationPreferencesViewModel()

    var body: some View {
        List {
            if let error = viewModel.lastError, viewModel.stored.isEmpty {
                errorBanner(error)
            }
            ForEach(NotificationCategory.allCases, id: \.self) { category in
                Section {
                    ForEach(NotificationChannel.allCases, id: \.self) { channel in
                        toggleRow(category: category, channel: channel)
                    }
                } header: {
                    HStack(spacing: 8) {
                        Image(systemName: category.systemImage)
                            .foregroundStyle(category.color)
                        Text(category.label)
                    }
                }
            }

            Section {
                Text("notifPrefs.footer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.stored.isEmpty { ProgressView() } }
        .navigationTitle(Text("profile.notificationPreferences"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.isSaving {
                ToolbarItem(placement: .topBarTrailing) {
                    ProgressView().controlSize(.small)
                }
            }
        }
        .task { if viewModel.stored.isEmpty { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    private func toggleRow(category: NotificationCategory, channel: NotificationChannel) -> some View {
        Toggle(isOn: Binding(
            get: { viewModel.isEnabled(category, channel) },
            set: { newValue in
                Task { await viewModel.toggle(category, channel, to: newValue) }
            }
        )) {
            Label(channel.label, systemImage: channel.systemImage)
        }
        .accessibilityLabel(Text("notifPrefs.toggle.a11y \(String(localized: category.label)) \(String(localized: channel.label))"))
    }

    private func errorBanner(_ message: String) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Label(String(localized: "notifPrefs.error.title"), systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(message).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

#Preview("LTR") { NavigationStack { NotificationPreferencesView() } }
#Preview("RTL") {
    NavigationStack { NotificationPreferencesView() }
        .environment(\.layoutDirection, .rightToLeft)
}
