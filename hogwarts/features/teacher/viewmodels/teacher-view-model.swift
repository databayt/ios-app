import Foundation
import SwiftUI

@MainActor
@Observable
final class TeacherViewModel {
    private(set) var classes: [TeacherClass] = []
    private(set) var schedule: [TeacherScheduleSlot] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    /// Currently selected scope — "Classes" lists sections, "Schedule" the
    /// week-grid view.
    var scope: TeacherScope = .classes

    private let actions: TeacherActions

    init(actions: TeacherActions = .init()) {
        self.actions = actions
    }

    /// Group schedule slots by weekday for the week view.
    var scheduleByDay: [(day: Int, slots: [TeacherScheduleSlot])] {
        let grouped = Dictionary(grouping: schedule, by: \.dayOfWeek)
        return grouped
            .map { (day: $0.key, slots: $0.value.sorted { ($0.startTime ?? "") < ($1.startTime ?? "") }) }
            .sorted { $0.day < $1.day }
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        // Fetch both endpoints in parallel — neither depends on the other.
        async let classesTask = actions.classes()
        async let scheduleTask = actions.schedule()

        do {
            classes = try await classesTask.data
            schedule = try await scheduleTask.data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

enum TeacherScope: Hashable, CaseIterable {
    case classes
    case schedule

    var label: LocalizedStringResource {
        switch self {
        case .classes:  "teacher.scope.classes"
        case .schedule: "teacher.scope.schedule"
        }
    }
}
