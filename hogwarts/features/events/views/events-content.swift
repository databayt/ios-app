import SwiftUI

// MARK: - EventsContent
//
// Inset-grouped list of school events grouped by Upcoming / Past, with a
// filter chip strip, type badge per row, pull-to-refresh, empty + error
// states. Mirrors Android's events screen.

struct EventsContent: View {
    @State private var viewModel = EventsViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            filterChips
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowSeparator(.hidden)

            if viewModel.items.isEmpty && !viewModel.isLoading {
                emptyState
            } else {
                if shouldShow(.upcoming) && !viewModel.upcomingItems.isEmpty {
                    Section(String(localized: "events.section.upcoming")) {
                        ForEach(viewModel.upcomingItems) { row(for: $0) }
                    }
                }
                if shouldShow(.past) && !viewModel.pastItems.isEmpty {
                    Section(String(localized: "events.section.past")) {
                        ForEach(viewModel.pastItems) { row(for: $0) }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("events.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Sub-views

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(EventsFilter.allCases, id: \.self) { f in
                    Button {
                        viewModel.filter = f
                    } label: {
                        Text(f.label)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background {
                                Capsule().fill(
                                    viewModel.filter == f
                                        ? Color.accentColor
                                        : Color(uiColor: .tertiarySystemFill)
                                )
                            }
                            .foregroundStyle(viewModel.filter == f ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(viewModel.filter == f ? .isSelected : [])
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func shouldShow(_ bucket: EventsFilter) -> Bool {
        switch viewModel.filter {
        case .all: return true
        case .upcoming: return bucket == .upcoming
        case .past: return bucket == .past
        }
    }

    private func row(for item: SchoolEventListItem) -> some View {
        NavigationLink(value: EventsRoute.detail(id: item.id)) {
            EventRow(item: item, locale: locale)
        }
    }

    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("events.empty.title").font(.headline)
                Text("events.empty.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .listRowBackground(Color.clear)
        }
    }
}

// MARK: - Row

private struct EventRow: View {
    let item: SchoolEventListItem
    let locale: Locale

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            dateBadge
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.title)
                        .font(.body.weight(.semibold))
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    typeChip
                }
                if let location = item.location, !location.isEmpty {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let time = formattedTimeRange {
                    Label(time, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private var dateBadge: some View {
        let comps = item.startDate.map { Calendar.current.dateComponents([.day, .month], from: $0) }
        let day = comps?.day.map { "\($0)" } ?? "—"
        let month = comps?.month.flatMap { Calendar.current.shortMonthSymbols[safe: $0 - 1] } ?? ""
        return VStack(spacing: 2) {
            Text(month.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(item.kind.color)
            Text(day)
                .font(.title2.weight(.bold))
                .monospacedDigit()
        }
        .frame(width: 48, height: 56)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(item.kind.color.opacity(0.12)))
    }

    private var typeChip: some View {
        Label(item.kind.label, systemImage: item.kind.systemImage)
            .labelStyle(.iconOnly)
            .font(.caption2)
            .foregroundStyle(item.kind.color)
            .accessibilityLabel(Text(item.kind.label))
    }

    private var formattedTimeRange: String? {
        guard let start = item.startTime, !start.isEmpty else { return nil }
        if let end = item.endTime, !end.isEmpty {
            return "\(start) – \(end)"
        }
        return start
    }
}

// MARK: - Routing

enum EventsRoute: Hashable {
    case detail(id: String)
}

// MARK: - Helper

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview("LTR") {
    NavigationStack {
        EventsContent()
            .navigationDestination(for: EventsRoute.self) { route in
                if case .detail(let id) = route { EventDetailView(id: id) }
            }
    }
}

#Preview("RTL") {
    NavigationStack {
        EventsContent()
            .navigationDestination(for: EventsRoute.self) { route in
                if case .detail(let id) = route { EventDetailView(id: id) }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
