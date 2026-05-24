import SwiftUI

// MARK: - ExamsContent
//
// Inset-grouped list of exams sectioned by Upcoming / Past with a filter
// chip strip. Each row shows date badge + subject + duration + type chip
// + status chip. Tap pushes `ExamDetailView`.

struct ExamsContent: View {
    @State private var viewModel = ExamsViewModel()
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
                    Section(String(localized: "exams.section.upcoming")) {
                        ForEach(viewModel.upcomingItems) { row(for: $0) }
                    }
                }
                if shouldShow(.past) && !viewModel.pastItems.isEmpty {
                    Section(String(localized: "exams.section.past")) {
                        ForEach(viewModel.pastItems) { row(for: $0) }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("exams.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.items.isEmpty { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ExamsFilter.allCases, id: \.self) { f in
                    Button { viewModel.filter = f } label: {
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
        }
    }

    private func shouldShow(_ bucket: ExamsFilter) -> Bool {
        switch viewModel.filter {
        case .all:      return true
        case .upcoming: return bucket == .upcoming
        case .past:     return bucket == .past
        }
    }

    private func row(for item: SchoolExamListItem) -> some View {
        NavigationLink(value: ExamsRoute.detail(id: item.id)) {
            ExamRow(item: item, locale: locale)
        }
    }

    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "graduationcap")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("exams.empty.title").font(.headline)
                Text("exams.empty.subtitle")
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

private struct ExamRow: View {
    let item: SchoolExamListItem
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
                if let subject = item.subjectName, !subject.isEmpty {
                    Label(subject, systemImage: "book.closed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    if let duration = item.formattedDuration {
                        Label(duration, systemImage: "clock")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    if let total = item.totalMarks {
                        Label(
                            String(localized: "exams.row.marks \(total)"),
                            systemImage: "number"
                        )
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    }
                    statusChip
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private var dateBadge: some View {
        let comps = item.examDate.map { Calendar.current.dateComponents([.day, .month], from: $0) }
        let day = comps?.day.map { "\($0)" } ?? "—"
        let month = comps?.month.flatMap { Calendar.current.shortMonthSymbols[safe: $0 - 1] } ?? ""
        return VStack(spacing: 2) {
            Text(month.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(item.typeKind.color)
            Text(day)
                .font(.title2.weight(.bold))
                .monospacedDigit()
        }
        .frame(width: 48, height: 56)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(item.typeKind.color.opacity(0.12)))
    }

    private var typeChip: some View {
        Label(item.typeKind.label, systemImage: item.typeKind.systemImage)
            .labelStyle(.titleAndIcon)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(item.typeKind.color.opacity(0.15)))
            .foregroundStyle(item.typeKind.color)
    }

    @ViewBuilder
    private var statusChip: some View {
        if item.statusKind != .unknown && item.statusKind != .scheduled {
            Text(item.statusKind.label)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Capsule().fill(item.statusKind.color.opacity(0.15)))
                .foregroundStyle(item.statusKind.color)
        }
    }
}

// MARK: - Routing

enum ExamsRoute: Hashable {
    case detail(id: String)
    case attempt(id: String, title: String)
    case certificate(id: String)
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview("LTR") {
    NavigationStack {
        ExamsContent()
            .navigationDestination(for: ExamsRoute.self) { route in
                if case .detail(let id) = route { ExamDetailView(id: id) }
            }
    }
}

#Preview("RTL") {
    NavigationStack {
        ExamsContent()
            .navigationDestination(for: ExamsRoute.self) { route in
                if case .detail(let id) = route { ExamDetailView(id: id) }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
