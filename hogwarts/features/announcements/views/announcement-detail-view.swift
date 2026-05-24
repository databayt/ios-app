import SwiftUI

// MARK: - AnnouncementDetailView
//
// Detail screen for one announcement — fetches `/mobile/announcements/:id`
// and renders header (priority/pinned/featured badges + title + author/date),
// the body, and a metadata section (target class, target role, read count).
// Mirrors Android's `AnnouncementDetailScreen`.

struct AnnouncementDetailView: View {
    let id: String

    @State private var detail: AnnouncementDetail?
    @State private var isLoading = false
    @State private var lastError: String?
    @Environment(\.locale) private var locale

    private let actions = AnnouncementsActions()

    var body: some View {
        Group {
            if let detail {
                content(for: detail)
            } else if let lastError {
                errorState(lastError)
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(Text("announcements.detail.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let detail {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareString(for: detail)) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel(Text("announcements.share"))
                }
            }
        }
        .task { await load() }
        .refreshable { await load() }
    }

    // MARK: - Loaded content

    private func content(for detail: AnnouncementDetail) -> some View {
        List {
            Section {
                headerCard(for: detail).listRowSeparator(.hidden)
            }

            Section(String(localized: "announcements.detail.section.body")) {
                Text(detail.content)
                    .font(.body)
                    .padding(.vertical, 4)
                    .accessibilityLabel(Text("announcements.detail.body.a11y"))
            }

            if hasMetadata(detail) {
                Section(String(localized: "announcements.detail.section.meta")) {
                    if let cls = detail.targetClass {
                        LabeledContent(
                            String(localized: "announcements.detail.meta.targetClass"),
                            value: cls.name
                        )
                    }
                    if let role = detail.targetRole, !role.isEmpty {
                        LabeledContent(
                            String(localized: "announcements.detail.meta.targetRole"),
                            value: role.capitalized
                        )
                    }
                    if let scope = detail.scope, !scope.isEmpty {
                        LabeledContent(
                            String(localized: "announcements.detail.meta.scope"),
                            value: scope.capitalized
                        )
                    }
                    if let expires = detail.expiresAt {
                        LabeledContent(
                            String(localized: "announcements.detail.meta.expires"),
                            value: expires.formatted(date: .abbreviated, time: .shortened)
                        )
                    }
                    LabeledContent(
                        String(localized: "announcements.detail.meta.readCount"),
                        value: detail.readCount.formatted(.number.locale(locale))
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func headerCard(for detail: AnnouncementDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                priorityChip(for: detail)
                if detail.isPinned {
                    chip(label: "announcements.detail.pinned",
                         systemImage: "pin.fill",
                         color: .accentOrange)
                }
                if detail.isFeatured {
                    chip(label: "announcements.detail.featured",
                         systemImage: "star.fill",
                         color: .accentYellow)
                }
            }

            Text(detail.title)
                .font(.title2.weight(.bold))
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 12) {
                if let author = detail.authorName, !author.isEmpty {
                    Label(author, systemImage: "person.crop.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let date = detail.publishedAt {
                    Label(
                        date.formatted(date: .long, time: .shortened),
                        systemImage: "calendar"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func priorityChip(for detail: AnnouncementDetail) -> some View {
        let kind = detail.priorityKind
        if kind != .unknown {
            chip(label: kind.label, systemImage: kind.systemImage, color: kind.color)
        }
    }

    private func chip(label: LocalizedStringResource, systemImage: String, color: Color) -> some View {
        Label(label, systemImage: systemImage)
            .labelStyle(.titleAndIcon)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(color.opacity(0.15)))
            .foregroundStyle(color)
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("announcements.detail.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "announcements.retry")) {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func hasMetadata(_ d: AnnouncementDetail) -> Bool {
        d.targetClass != nil
            || (d.targetRole?.isEmpty == false)
            || (d.scope?.isEmpty == false)
            || d.expiresAt != nil
            || d.readCount > 0
    }

    private func shareString(for d: AnnouncementDetail) -> String {
        var lines = [d.title, "", d.content]
        if let author = d.authorName, !author.isEmpty {
            lines.append("")
            lines.append(String(localized: "announcements.share.by \(author)"))
        }
        return lines.joined(separator: "\n")
    }

    private func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            detail = try await actions.detail(id: id)
        } catch is CancellationError {
            // Ignore — view disappeared.
        } catch {
            lastError = error.localizedDescription
        }
    }
}

#Preview("LTR") {
    NavigationStack { AnnouncementDetailView(id: "preview") }
}

#Preview("RTL") {
    NavigationStack { AnnouncementDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
