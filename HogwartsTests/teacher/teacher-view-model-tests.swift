import Foundation
import Testing
@testable import Hogwarts

@Suite("TeacherViewModel.scheduleByDay")
@MainActor
struct TeacherViewModelScheduleTests {

    @Test("Groups slots by weekday")
    func grouping() {
        let vm = TeacherViewModel()
        vm._setScheduleForTests([
            slot(day: 1, start: "08:00"),
            slot(day: 1, start: "09:00"),
            slot(day: 3, start: "10:00"),
        ])
        let groups = vm.scheduleByDay
        #expect(groups.count == 2)
        #expect(groups.first?.day == 1)
        #expect(groups.first?.slots.count == 2)
    }

    @Test("Slots within a day are sorted by start time")
    func intradaySort() {
        let vm = TeacherViewModel()
        vm._setScheduleForTests([
            slot(day: 2, start: "13:00"),
            slot(day: 2, start: "08:30"),
            slot(day: 2, start: "11:15"),
        ])
        let day = vm.scheduleByDay.first
        #expect(day?.slots.map(\.startTime) == ["08:30", "11:15", "13:00"])
    }

    @Test("Days are sorted Sunday-first (0..6)")
    func dayOrder() {
        let vm = TeacherViewModel()
        vm._setScheduleForTests([
            slot(day: 4, start: "08:00"),
            slot(day: 0, start: "08:00"),
            slot(day: 2, start: "08:00"),
        ])
        #expect(vm.scheduleByDay.map(\.day) == [0, 2, 4])
    }

    private func slot(day: Int, start: String) -> TeacherScheduleSlot {
        TeacherScheduleSlot(
            id: UUID().uuidString,
            dayOfWeek: day,
            subjectName: "Subject",
            sectionName: "A",
            gradeName: "Grade 5",
            classroom: "Room 1",
            periodName: "P1",
            startTime: start,
            endTime: nil
        )
    }
}

extension TeacherViewModel {
    func _setScheduleForTests(_ slots: [TeacherScheduleSlot]) {
        self.schedule = slots
    }
}

@Suite("TeacherScope")
struct TeacherScopeTests {

    @Test("Scope cases cover both modes")
    func cases() {
        #expect(TeacherScope.allCases.count == 2)
        #expect(TeacherScope.allCases.contains(.classes))
        #expect(TeacherScope.allCases.contains(.schedule))
    }
}
