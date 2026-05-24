import SwiftUI

// Role-specific subviews of `AttendanceContent`. Split out of the parent
// file so it stays under the SwiftLint 600-line threshold and so each
// role's UI lives next to its peers, easier to tweak in isolation.

// MARK: - Teacher

struct TeacherAttendanceContent: View {
    @Bindable var viewModel: AttendanceViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Class selector
            if !viewModel.teacherClasses.isEmpty {
                Picker(String(localized: "attendance.class"), selection: Binding(
                    get: { viewModel.selectedClassId ?? "" },
                    set: { newValue in
                        viewModel.selectedClassId = newValue
                        viewModel.filterByClass(newValue.isEmpty ? nil : newValue)
                    }
                )) {
                    Text(String(localized: "filter.allClasses")).tag("")
                    ForEach(viewModel.teacherClasses) { cls in
                        Text(cls.displayName).tag(cls.id)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel(String(localized: "a11y.attendance.classFilter"))
                .padding(.horizontal)
            }

            // Stats summary (only when viewing a single student)
            if viewModel.filters.studentId != nil, let stats = viewModel.statsDisplay {
                AttendanceStatsBar(stats: stats)
            }

            AttendanceToolbar(viewModel: viewModel)

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .loaded:
                    AttendanceTable(
                        rows: viewModel.rows,
                        canEdit: true,
                        onEdit: { row in
                            viewModel.showMarkForm(studentId: row.studentId)
                        }
                    )
                    .refreshable { await viewModel.refresh() }

                case .empty:
                    EmptyStateView(
                        title: String(localized: "attendance.empty.title"),
                        message: String(localized: "attendance.empty.teacher.message"),
                        systemImage: "calendar.badge.checkmark",
                        action: { viewModel.showMarkClassForm(classId: "") },
                        actionTitle: String(localized: "attendance.action.markClass")
                    )

                case .error(let error):
                    ErrorStateView(
                        error: error,
                        retryAction: { Task { await viewModel.loadAttendance() } }
                    )
                }
            }
        }
    }
}

// MARK: - Student

struct StudentAttendanceContent: View {
    @Bindable var viewModel: AttendanceViewModel
    @State private var displayMode: AttendanceDisplayMode = .list

    enum AttendanceDisplayMode: String, CaseIterable {
        case list, calendar, charts

        var label: String {
            switch self {
            case .list:     return String(localized: "attendance.view.list")
            case .calendar: return String(localized: "attendance.view.calendar")
            case .charts:   return String(localized: "attendance.view.charts")
            }
        }

        var icon: String {
            switch self {
            case .list:     return "list.bullet"
            case .calendar: return "calendar"
            case .charts:   return "chart.pie"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if let stats = viewModel.statsDisplay {
                AttendanceStatsCard(stats: stats).padding()
            }

            Picker(String(localized: "attendance.view.mode"), selection: $displayMode) {
                ForEach(AttendanceDisplayMode.allCases, id: \.self) { mode in
                    Label(mode.label, systemImage: mode.icon).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .accessibilityLabel(String(localized: "a11y.attendance.displayMode"))
            .padding(.horizontal)
            .padding(.vertical, 8)

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .loaded:
                    historyContent
                        .refreshable { await viewModel.refresh() }

                case .empty:
                    EmptyStateView(
                        title: String(localized: "attendance.empty.title"),
                        message: String(localized: "attendance.empty.student.message"),
                        systemImage: "calendar.badge.checkmark"
                    )

                case .error(let error):
                    ErrorStateView(
                        error: error,
                        retryAction: { Task { await viewModel.loadAttendance() } }
                    )
                }
            }
        }
    }

    /// Pulled out so the `switch` above stays scannable.
    @ViewBuilder
    private var historyContent: some View {
        switch displayMode {
        case .charts:
            if let stats = viewModel.statsDisplay {
                ScrollView {
                    AttendanceChartsView(stats: stats, records: viewModel.rows)
                }
            }
        case .calendar:
            ScrollView {
                AttendanceCalendarView(
                    rows: viewModel.rows,
                    selectedDate: $viewModel.selectedDate
                )
                .padding(.vertical)
            }
        case .list:
            List {
                ForEach(viewModel.rows) { row in
                    AttendanceHistoryRow(row: row)
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Guardian

struct GuardianAttendanceContent: View {
    @Bindable var viewModel: AttendanceViewModel

    var body: some View {
        VStack(spacing: 0) {
            if let stats = viewModel.statsDisplay {
                AttendanceStatsCard(stats: stats).padding()
            }

            NavigationLink {
                ExcuseListView()
            } label: {
                Label(
                    String(localized: "excuse.viewAll"),
                    systemImage: "doc.text.magnifyingglass"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)

            if AttendanceValidation.canSubmitExcuse(for: viewModel.selectedDate) {
                Button {
                    if let studentId = viewModel.filters.studentId {
                        viewModel.showExcuseForm(studentId: studentId, date: viewModel.selectedDate)
                    }
                } label: {
                    Label(
                        String(localized: "attendance.action.submitExcuse"),
                        systemImage: "doc.text"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }

            Group {
                switch viewModel.viewState {
                case .idle, .loading:
                    LoadingView()

                case .loaded:
                    List {
                        ForEach(viewModel.rows) { row in
                            AttendanceHistoryRow(row: row)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.refresh() }

                case .empty:
                    EmptyStateView(
                        title: String(localized: "attendance.empty.title"),
                        message: String(localized: "attendance.empty.guardian.message"),
                        systemImage: "calendar.badge.checkmark"
                    )

                case .error(let error):
                    ErrorStateView(
                        error: error,
                        retryAction: { Task { await viewModel.loadAttendance() } }
                    )
                }
            }
        }
    }
}

// MARK: - View only

struct ViewOnlyAttendanceContent: View {
    @Bindable var viewModel: AttendanceViewModel

    var body: some View {
        VStack {
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
                .padding()

            Text(String(localized: "attendance.noAccess"))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
