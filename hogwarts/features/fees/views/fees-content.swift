import SwiftUI

// MARK: - FeesContent
//
// Top summary card (Paid progress + Outstanding total + Overdue count) +
// status-chip filter (All / Pending / Paid / Overdue) + list of fee
// records with status badges and due-date cues.
//
// `studentId` is best-effort: the backend resolves it from the JWT for
// student users; guardian flows pass an explicit child ID once the
// `child-selector` is wired into this screen.

struct FeesContent: View {
    var studentId: String?

    @State private var viewModel = FeesViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            if let summary = viewModel.summary {
                Section {
                    SummaryCard(summary: summary, locale: locale)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }

            Section {
                filterChips
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }

            if viewModel.filteredItems.isEmpty && !viewModel.isLoading {
                emptyState
            } else {
                Section(String(localized: "fees.section.records")) {
                    ForEach(viewModel.filteredItems) { record in
                        NavigationLink(value: FeesRoute.detail(id: record.id)) {
                            FeeRow(record: record, locale: locale)
                        }
                    }
                }
            }

            if let error = viewModel.lastError, viewModel.items.isEmpty {
                errorState(error)
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("fees.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.items.isEmpty { await viewModel.load(studentId: studentId) } }
        .refreshable { await viewModel.load(studentId: studentId) }
    }

    // MARK: - Filter chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: Text("fees.filter.all"),
                     count: viewModel.count(for: nil),
                     selected: viewModel.statusFilter == nil) {
                    viewModel.statusFilter = nil
                }
                ForEach([FeeStatus.pending, .paid, .overdue, .partial], id: \.self) { status in
                    chip(title: Text(status.label),
                         count: viewModel.count(for: status),
                         selected: viewModel.statusFilter == status) {
                        viewModel.statusFilter = (viewModel.statusFilter == status) ? nil : status
                    }
                }
            }
        }
    }

    private func chip(title: Text, count: Int, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                title.font(.subheadline.weight(.medium))
                if count > 0 {
                    Text("\(count)")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(selected ? .white.opacity(0.3) : Color(uiColor: .quaternarySystemFill)))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Capsule().fill(selected ? Color.accentColor : Color(uiColor: .tertiarySystemFill)))
            .foregroundStyle(selected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    // MARK: - States

    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "creditcard")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("fees.empty.title").font(.headline)
                Text("fees.empty.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .listRowBackground(Color.clear)
        }
    }

    private func errorState(_ message: String) -> some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 36))
                    .foregroundStyle(.orange)
                Text("fees.error.title").font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button(String(localized: "fees.retry")) {
                    Task { await viewModel.load(studentId: studentId) }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .listRowBackground(Color.clear)
        }
    }
}

// MARK: - Summary card

private struct SummaryCard: View {
    let summary: FeeSummary
    let locale: Locale

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("fees.summary.outstanding")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
                .textCase(.uppercase)
            Text(summary.totalPending.formattedAsCurrency(locale: locale))
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)

            ProgressView(value: summary.paidProgress)
                .tint(.white)
                .background(Color.white.opacity(0.18))

            HStack(spacing: 14) {
                statBlock(label: "fees.summary.paid",
                          value: summary.totalPaid.formattedAsCurrency(locale: locale))
                Spacer()
                statBlock(label: "fees.summary.records",
                          value: "\(summary.totalRecords)")
                Spacer()
                statBlock(label: "fees.summary.overdue",
                          value: "\(summary.overdueCount)",
                          highlightWhenNonZero: true)
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [.accentBlue, .accentPurple.opacity(0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func statBlock(label: LocalizedStringResource, value: String, highlightWhenNonZero: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(highlightWhenNonZero && value != "0" ? .yellow : .white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.78))
        }
    }
}

// MARK: - Fee row

private struct FeeRow: View {
    let record: FeeRecord
    let locale: Locale

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: record.statusKind.systemImage)
                .font(.title3)
                .foregroundStyle(record.statusKind.color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(record.feeType ?? String(localized: "fees.type.unknown"))
                        .font(.body.weight(.medium))
                    Spacer(minLength: 8)
                    Text(record.amount.formattedAsCurrency(locale: locale))
                        .font(.body.weight(.semibold))
                        .monospacedDigit()
                }
                HStack(spacing: 8) {
                    Label(record.statusKind.label, systemImage: record.statusKind.systemImage)
                        .labelStyle(.titleOnly)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(record.statusKind.color.opacity(0.15)))
                        .foregroundStyle(record.statusKind.color)

                    if let due = record.dueDate {
                        dueLabel(due)
                    }

                    if record.paidAmount > 0 && record.paidAmount < record.amount {
                        Text("fees.row.partialPaid \(record.paidAmount.formattedAsCurrency(locale: locale))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private func dueLabel(_ due: Date) -> some View {
        let days = record.daysUntilDue() ?? 0
        let key: LocalizedStringResource = {
            if days < 0 { return "fees.row.overdueDays \(-days)" }
            if days == 0 { return "fees.row.dueToday" }
            return "fees.row.dueInDays \(days)"
        }()
        return Text(key)
            .font(.caption2)
            .foregroundStyle(days < 0 ? .red : .secondary)
            .accessibilityLabel(Text(due.formatted(date: .abbreviated, time: .omitted).description))
    }
}

// MARK: - Routing

enum FeesRoute: Hashable {
    case detail(id: String)
}

#Preview("LTR") {
    NavigationStack {
        FeesContent()
            .navigationDestination(for: FeesRoute.self) { route in
                if case .detail(let id) = route { FeeDetailView(id: id) }
            }
    }
}

#Preview("RTL") {
    NavigationStack {
        FeesContent()
            .navigationDestination(for: FeesRoute.self) { route in
                if case .detail(let id) = route { FeeDetailView(id: id) }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
