import SwiftUI

// MARK: - TeacherContent
//
// Two-mode screen: "Classes" lists section+subject pairs (with student
// count); "Schedule" groups timetable slots by weekday. Picker at top
// flips between modes; both modes share one fetch in `load()`.

struct TeacherContent: View {
    @State private var viewModel = TeacherViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        VStack(spacing: 0) {
            scopePicker
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            content
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.classes.isEmpty && viewModel.schedule.isEmpty { ProgressView() } }
        .navigationTitle(Text("teacher.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.classes.isEmpty { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    private var scopePicker: some View {
        Picker("teacher.scope.title", selection: $viewModel.scope) {
            ForEach(TeacherScope.allCases, id: \.self) { scope in
                Text(scope.label).tag(scope)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.scope {
        case .classes:  classesList
        case .schedule: scheduleList
        }
    }

    @ViewBuilder
    private var classesList: some View {
        if viewModel.classes.isEmpty && !viewModel.isLoading {
            empty(systemImage: "person.3", title: "teacher.empty.classes.title", subtitle: "teacher.empty.classes.subtitle")
        } else {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.classes) { item in
                        ClassCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }

    @ViewBuilder
    private var scheduleList: some View {
        if viewModel.schedule.isEmpty && !viewModel.isLoading {
            empty(systemImage: "calendar", title: "teacher.empty.schedule.title", subtitle: "teacher.empty.schedule.subtitle")
        } else {
            List {
                ForEach(viewModel.scheduleByDay, id: \.day) { (day, slots) in
                    Section(String(localized: TeacherScheduleSlot.weekdayKey(for: day))) {
                        ForEach(slots) { slot in
                            ScheduleRow(slot: slot)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    private func empty(systemImage: String, title: LocalizedStringResource, subtitle: LocalizedStringResource) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text(title).font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}

// MARK: - Cards / Rows

private struct ClassCard: View {
    let item: TeacherClass

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.3.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.accentBlue))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.subjectName ?? item.sectionName)
                    .font(.body.weight(.semibold))
                Text(item.gradeName.map { "\($0) · \(item.sectionName)" } ?? item.sectionName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(item.studentCount)")
                    .font(.title3.weight(.heavy))
                    .monospacedDigit()
                Text("teacher.classes.students")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct ScheduleRow: View {
    let slot: TeacherScheduleSlot

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(slot.startTime ?? "—")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                Text(slot.endTime ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            .frame(width: 64, alignment: .leading)
            VStack(alignment: .leading, spacing: 4) {
                Text(slot.subjectName ?? String(localized: "teacher.schedule.unknownSubject"))
                    .font(.body.weight(.medium))
                HStack(spacing: 8) {
                    if let section = slot.sectionName {
                        Label(slot.gradeName.map { "\($0) · \(section)" } ?? section,
                              systemImage: "person.3")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let room = slot.classroom {
                        Label(room, systemImage: "door.right.hand.open")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

extension TeacherScheduleSlot {
    /// Resolve a backend day-of-week int (0–6, Sun-first) into a catalog
    /// key for `String(localized:)`. Helper lives here so both the row and
    /// the section header use the same mapping.
    static func weekdayKey(for day: Int) -> LocalizedStringResource {
        switch day {
        case 0: "weekday.sun"
        case 1: "weekday.mon"
        case 2: "weekday.tue"
        case 3: "weekday.wed"
        case 4: "weekday.thu"
        case 5: "weekday.fri"
        case 6: "weekday.sat"
        default: "weekday.unknown"
        }
    }
}

#Preview("LTR") { NavigationStack { TeacherContent() } }
#Preview("RTL") {
    NavigationStack { TeacherContent() }
        .environment(\.layoutDirection, .rightToLeft)
}
