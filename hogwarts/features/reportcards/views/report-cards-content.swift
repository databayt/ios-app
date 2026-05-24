import SwiftUI

// MARK: - ReportCardsContent
//
// Vertical list of term cards. Each card surfaces overall grade chip + GPA,
// rank, and attendance rate so the parent can scan progress without
// drilling into a detail view. Tap pushes `ReportCardDetailView` which
// shows per-subject grades.

struct ReportCardsContent: View {
    @State private var viewModel = ReportCardsViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.items.isEmpty && !viewModel.isLoading {
                    emptyState.padding(.top, 60)
                }
                ForEach(viewModel.items) { item in
                    NavigationLink(value: ReportCardsRoute.detail(id: item.id)) {
                        ReportCardSummaryCard(item: item, locale: locale)
                    }
                    .buttonStyle(.plain)
                }
                if let error = viewModel.lastError {
                    errorBanner(error)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("reportCards.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.items.isEmpty { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("reportCards.empty.title").font(.headline)
            Text("reportCards.empty.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func errorBanner(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(String(localized: "reportCards.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
            Button(String(localized: "reportCards.retry")) {
                Task { await viewModel.load() }
            }
            .buttonStyle(.bordered)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Card

private struct ReportCardSummaryCard: View {
    let item: ReportCardListItem
    let locale: Locale

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.termName ?? String(localized: "reportCards.term.unknown"))
                        .font(.headline)
                    if let date = item.publishedAt {
                        Text(date.formatted(.dateTime.month(.wide).year().locale(locale)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                gradeBadge
            }

            HStack(spacing: 10) {
                statTile(
                    title: "reportCards.stat.gpa",
                    value: item.overallGpa.map { String(format: "%.2f", $0) } ?? "—",
                    color: item.gradeColor
                )
                if let rank = item.rank {
                    statTile(
                        title: "reportCards.stat.rank",
                        value: item.totalStudents.map { "\(rank) / \($0)" } ?? "\(rank)",
                        color: .accentBlue
                    )
                }
                if let attendance = item.attendanceRate {
                    statTile(
                        title: "reportCards.stat.attendance",
                        value: attendance.formatted(.percent.precision(.fractionLength(0))),
                        color: attendance >= 0.9 ? .accentGreen : .accentOrange
                    )
                }
            }

            if item.pdfUrl != nil {
                Label(String(localized: "reportCards.pdfAvailable"), systemImage: "doc.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var gradeBadge: some View {
        if let g = item.overallGrade, !g.isEmpty {
            Text(g)
                .font(.title3.weight(.heavy))
                .frame(width: 44, height: 44)
                .background(Circle().fill(item.gradeColor.opacity(0.18)))
                .foregroundStyle(item.gradeColor)
        }
    }

    private func statTile(title: LocalizedStringResource, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(color)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(uiColor: .tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - Routing

enum ReportCardsRoute: Hashable {
    case detail(id: String)
}

#Preview("LTR") {
    NavigationStack {
        ReportCardsContent()
            .navigationDestination(for: ReportCardsRoute.self) { route in
                if case .detail(let id) = route { ReportCardDetailView(id: id) }
            }
    }
}

#Preview("RTL") {
    NavigationStack {
        ReportCardsContent()
            .navigationDestination(for: ReportCardsRoute.self) { route in
                if case .detail(let id) = route { ReportCardDetailView(id: id) }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
