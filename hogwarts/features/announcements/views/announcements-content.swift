import SwiftUI

// MARK: - AnnouncementsContent
//
// Inset-grouped list of announcements with priority filter chips, pull-to-
// refresh, empty state, and a recent / older split. Tapping a row pushes
// `AnnouncementDetailView`. Mirrors Android's `AnnouncementsScreen`.
//
// Designed to live inside a `NavigationStack` (provided by the parent —
// either the Notifications tab or the home-screen sheet).

struct AnnouncementsContent: View {
    @State private var viewModel = AnnouncementsViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            filterChips
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowSeparator(.hidden)

            if let error = viewModel.lastError, viewModel.items.isEmpty {
                errorState(error)
            } else if viewModel.items.isEmpty && !viewModel.isLoading {
                emptyState
            } else {
                if !viewModel.recentItems.isEmpty {
                    Section(String(localized: "announcements.section.recent")) {
                        ForEach(viewModel.recentItems) { item in
                            row(for: item)
                        }
                    }
                }
                if !viewModel.olderItems.isEmpty {
                    Section(String(localized: "announcements.section.older")) {
                        ForEach(viewModel.olderItems) { item in
                            row(for: item)
                        }
                    }
                }
                if let error = viewModel.lastError {
                    Section {
                        Text(String(localized: "announcements.cached.warning"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("announcements.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Sub-views

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AnnouncementsFilter.allCases, id: \.self) { filter in
                    Button {
                        viewModel.selectedFilter = filter
                    } label: {
                        Text(filter.label)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background {
                                Capsule().fill(
                                    viewModel.selectedFilter == filter
                                        ? Color.accentColor
                                        : Color(uiColor: .tertiarySystemFill)
                                )
                            }
                            .foregroundStyle(viewModel.selectedFilter == filter ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(viewModel.selectedFilter == filter ? .isSelected : [])
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func row(for item: AnnouncementListItem) -> some View {
        NavigationLink(value: AnnouncementsRoute.detail(id: item.id)) {
            AnnouncementRow(item: item, locale: locale)
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "megaphone")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("announcements.empty.title")
                    .font(.headline)
                Text("announcements.empty.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .listRowBackground(Color.clear)
        }
    }

    private func errorState(_ message: String) -> some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 36))
                    .foregroundStyle(.orange)
                Text("announcements.error.title").font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button(String(localized: "announcements.retry")) {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .listRowBackground(Color.clear)
        }
    }
}

// MARK: - Row

private struct AnnouncementRow: View {
    let item: AnnouncementListItem
    let locale: Locale

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.body.weight(.semibold))
                    .lineLimit(2)
                Spacer(minLength: 8)
                priorityBadge
            }

            Text(item.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 8) {
                if let date = item.publishedAt {
                    Label(
                        date.formatted(.relative(presentation: .named).locale(locale)),
                        systemImage: "clock"
                    )
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                }
                if let author = item.authorName, !author.isEmpty {
                    Label(author, systemImage: "person.crop.circle")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var priorityBadge: some View {
        let kind = item.priorityKind
        if kind != .unknown {
            Label(kind.label, systemImage: kind.systemImage)
                .labelStyle(.titleAndIcon)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(kind.color.opacity(0.15)))
                .foregroundStyle(kind.color)
        }
    }
}

// MARK: - Routing

enum AnnouncementsRoute: Hashable {
    case detail(id: String)
}

#Preview("LTR") {
    NavigationStack {
        AnnouncementsContent()
            .navigationDestination(for: AnnouncementsRoute.self) { route in
                if case .detail(let id) = route {
                    AnnouncementDetailView(id: id)
                }
            }
    }
}

#Preview("RTL") {
    NavigationStack {
        AnnouncementsContent()
            .navigationDestination(for: AnnouncementsRoute.self) { route in
                if case .detail(let id) = route {
                    AnnouncementDetailView(id: id)
                }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
