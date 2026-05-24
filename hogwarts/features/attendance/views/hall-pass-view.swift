import SwiftUI

// MARK: - HallPassView
//
// Inset-grouped list of hall passes with a top summary banner showing
// active vs overdue counts. Tap a row to see destination + countdown.

struct HallPassView: View {
    var studentId: String?

    @State private var viewModel = HallPassViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        List {
            if viewModel.activeCount > 0 || viewModel.overdueCount > 0 {
                Section {
                    summaryBanner
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
                Section {
                    ForEach(viewModel.filteredItems) { pass in
                        HallPassRow(pass: pass, locale: locale)
                    }
                }
            }
            if let error = viewModel.lastError {
                errorBanner(error)
            }
        }
        .listStyle(.insetGrouped)
        .overlay { if viewModel.isLoading && viewModel.items.isEmpty { ProgressView() } }
        .navigationTitle(Text("hallPass.title"))
        .navigationBarTitleDisplayMode(.inline)
        .task { if viewModel.items.isEmpty { await viewModel.load(studentId: studentId) } }
        .refreshable { await viewModel.load(studentId: studentId) }
    }

    // MARK: - Summary banner

    private var summaryBanner: some View {
        HStack(spacing: 14) {
            statTile(value: viewModel.activeCount, label: "hallPass.summary.active", tint: .accentBlue)
            if viewModel.overdueCount > 0 {
                statTile(value: viewModel.overdueCount, label: "hallPass.summary.overdue", tint: .accentRed)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func statTile(value: Int, label: LocalizedStringResource, tint: Color) -> some View {
        HStack(spacing: 8) {
            Text("\(value)")
                .font(.title3.weight(.heavy))
                .monospacedDigit()
                .foregroundStyle(tint)
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(tint.opacity(0.10)))
    }

    // MARK: - Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: Text("hallPass.filter.all"), isSelected: viewModel.statusFilter == nil) {
                    viewModel.statusFilter = nil
                }
                ForEach([HallPassStatus.active, .overdue, .returned, .cancelled], id: \.self) { status in
                    chip(title: Text(status.label), isSelected: viewModel.statusFilter == status) {
                        viewModel.statusFilter = (viewModel.statusFilter == status) ? nil : status
                    }
                }
            }
        }
    }

    private func chip(title: Text, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            title
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill)))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: - States

    private var emptyState: some View {
        Section {
            VStack(spacing: 12) {
                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 44))
                    .foregroundStyle(.tertiary)
                Text("hallPass.empty.title").font(.headline)
                Text("hallPass.empty.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .listRowBackground(Color.clear)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        Section {
            Label(String(localized: "hallPass.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - Row

private struct HallPassRow: View {
    let pass: HallPass
    let locale: Locale

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: pass.statusKind.systemImage)
                .font(.title3)
                .foregroundStyle(pass.statusKind.color)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(pass.destination ?? String(localized: "hallPass.destination.unknown"))
                        .font(.body.weight(.medium))
                    Spacer(minLength: 8)
                    Text(pass.statusKind.label)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(pass.statusKind.color.opacity(0.15)))
                        .foregroundStyle(pass.statusKind.color)
                }
                if let name = pass.studentName {
                    Label(name, systemImage: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    Label(
                        pass.issuedAt.formatted(.relative(presentation: .named).locale(locale)),
                        systemImage: "clock"
                    )
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                    if pass.statusKind == .active {
                        let remaining = pass.minutesRemaining()
                        if remaining < 0 {
                            Text("hallPass.row.overdueBy \(-remaining)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.red)
                        } else {
                            Text("hallPass.row.remaining \(remaining)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview("LTR") { NavigationStack { HallPassView() } }
#Preview("RTL") {
    NavigationStack { HallPassView() }
        .environment(\.layoutDirection, .rightToLeft)
}
