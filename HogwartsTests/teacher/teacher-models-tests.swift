import Foundation
import Testing
@testable import Hogwarts

@Suite("TeacherClass.displayName")
struct TeacherClassDisplayNameTests {

    @Test("Includes grade and subject when present")
    func full() {
        let cls = TeacherClass(
            sectionId: "s1", sectionName: "A",
            gradeName: "Grade 5", subjectName: "Math", studentCount: 28
        )
        #expect(cls.displayName == "Grade 5 · A — Math")
    }

    @Test("Skips grade when missing")
    func noGrade() {
        let cls = TeacherClass(
            sectionId: "s1", sectionName: "A",
            gradeName: nil, subjectName: "Math", studentCount: 28
        )
        #expect(cls.displayName == "A — Math")
    }

    @Test("Falls back to section name when no subject")
    func noSubject() {
        let cls = TeacherClass(
            sectionId: "s1", sectionName: "A",
            gradeName: nil, subjectName: nil, studentCount: 28
        )
        #expect(cls.displayName == "A")
    }

    @Test("ID combines sectionId and subject")
    func idComposition() {
        let a = TeacherClass(sectionId: "s1", sectionName: "X",
                             gradeName: nil, subjectName: "Math", studentCount: 0)
        let b = TeacherClass(sectionId: "s1", sectionName: "X",
                             gradeName: nil, subjectName: "Sci", studentCount: 0)
        #expect(a.id != b.id)  // distinct subjects → distinct ids
    }
}

@Suite("TeacherScheduleSlot.weekdayKey")
struct TeacherWeekdayTests {

    @Test("Maps day index to weekday key", arguments: [
        (0, "weekday.sun"),
        (1, "weekday.mon"),
        (2, "weekday.tue"),
        (3, "weekday.wed"),
        (4, "weekday.thu"),
        (5, "weekday.fri"),
        (6, "weekday.sat"),
    ])
    func mapsCanonical(day: Int, expectedKey: String) {
        let resource = TeacherScheduleSlot.weekdayKey(for: day)
        // LocalizedStringResource doesn't expose its key directly, but its
        // description includes the key — adequate for round-trip checking.
        #expect("\(resource)".contains(expectedKey))
    }

    @Test("Out-of-range day gets unknown")
    func unknownDay() {
        let resource = TeacherScheduleSlot.weekdayKey(for: 99)
        #expect("\(resource)".contains("weekday.unknown"))
    }
}
