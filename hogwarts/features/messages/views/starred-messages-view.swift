import SwiftUI

// MARK: - StarredMessagesView
//
// Two-mode list: when the search field is empty, shows starred messages
// sorted by star date; when the user types ≥ 2 chars, swaps to a global
// search across every conversation the user can read. Both modes use the
// same row layout.

struct StarredMessagesView: View {
    @State private var viewModel = StarredMessagesViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            if isShowingSearch {
                searchSection
            } else {
                starredSection
            }
            if let error = viewModel.lastError {
                errorBanner(error)
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("starred.title"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.query, prompt: Text("starred.search.prompt"))
        .task { if viewModel.items.isEmpty { await viewModel.loadStarred() } }
        .refreshable {
            await viewModel.loadStarred()
        }
    }

    private var isShowingSearch: Bool {
        viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }

    // MARK: - Sections

    @ViewBuilder
    private var starredSection: some View {
        if viewModel.items.isEmpty && !viewModel.isLoading {
            Section {
                emptyState(
                    systemImage: "star",
                    title: "starred.empty.title",
                    subtitle: "starred.empty.subtitle"
                )
            }
        } else {
            Section(String(localized: "starred.section.starred")) {
                ForEach(viewModel.items) { item in
                    StarredRow(item: item, locale: locale)
                }
            }
        }
    }

    @ViewBuilder
    private var searchSection: some View {
        if viewModel.isSearching && viewModel.searchHits.isEmpty {
            Section { ProgressView() }
        } else if viewModel.searchHits.isEmpty {
            Section {
                emptyState(
                    systemImage: "magnifyingglass",
                    title: "starred.search.empty.title",
                    subtitle: "starred.search.empty.subtitle"
                )
            }
        } else {
            Section(String(localized: "starred.search.results")) {
                ForEach(viewModel.searchHits) { hit in
                    SearchRow(hit: hit, locale: locale)
                }
            }
        }
    }

    // MARK: - Helpers

    private func emptyState(systemImage: String, title: LocalizedStringResource, subtitle: LocalizedStringResource) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
            Text(title).font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .listRowBackground(Color.clear)
    }

    private func errorBanner(_ message: String) -> some View {
        Section {
            Label(String(localized: "starred.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Rows

private struct StarredRow: View {
    let item: StarredMessage
    let locale: Locale

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.message.conversationTitle.isEmpty
                     ? item.message.senderName
                     : item.message.conversationTitle)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Spacer(minLength: 8)
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
            Text(item.message.content)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(3)
            HStack(spacing: 8) {
                Label(item.message.senderName, systemImage: "person.crop.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Label(
                    item.starredAt.formatted(.relative(presentation: .named).locale(locale)),
                    systemImage: "clock"
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

private struct SearchRow: View {
    let hit: MessageSearchHit
    let locale: Locale

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(hit.conversationTitle.isEmpty ? hit.senderName : hit.conversationTitle)
                .font(.body.weight(.semibold))
                .lineLimit(1)
            Text(hit.content)
                .font(.subheadline)
                .lineLimit(3)
            HStack(spacing: 8) {
                Label(hit.senderName, systemImage: "person.crop.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Label(
                    hit.sentAt.formatted(.relative(presentation: .named).locale(locale)),
                    systemImage: "clock"
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview("LTR") { NavigationStack { StarredMessagesView() } }
#Preview("RTL") {
    NavigationStack { StarredMessagesView() }
        .environment(\.layoutDirection, .rightToLeft)
}
