import Foundation
import Testing
@testable import Hogwarts

@Suite("SchoolEventDetail.timeParser")
struct EventTimeParserTests {

    @Test("Parses HH:mm 24h", arguments: [
        ("09:00", 9, 0),
        ("13:30", 13, 30),
        ("00:05", 0, 5),
        ("23:59", 23, 59),
    ])
    func parses24Hour(time: String, expectedHour: Int, expectedMinute: Int) {
        let parsed = SchoolEventDetail.timeParser(time)
        #expect(parsed?.hour == expectedHour)
        #expect(parsed?.minute == expectedMinute)
    }

    @Test("Parses h:mm a 12h", arguments: [
        ("9:00 AM", 9, 0),
        ("12:30 PM", 12, 30),
        ("1:15 PM", 13, 15),
        ("12:00 AM", 0, 0),
    ])
    func parses12Hour(time: String, expectedHour: Int, expectedMinute: Int) {
        let parsed = SchoolEventDetail.timeParser(time)
        #expect(parsed?.hour == expectedHour)
        #expect(parsed?.minute == expectedMinute)
    }

    @Test("Returns nil for malformed input", arguments: ["", "TBA", "noon", "12", ":30"])
    func rejectsJunk(_ raw: String) {
        #expect(SchoolEventDetail.timeParser(raw) == nil)
    }
}

@Suite("SchoolEventKind")
struct SchoolEventKindTests {

    @Test("Maps academic synonyms", arguments: ["academic", "exam", "lesson"])
    func academicSynonyms(_ raw: String) {
        #expect(SchoolEventKind(raw: raw) == .academic)
    }

    @Test("Maps sports synonyms", arguments: ["sports", "sport"])
    func sportsSynonyms(_ raw: String) {
        #expect(SchoolEventKind(raw: raw) == .sports)
    }

    @Test("Falls back to .other for unknown")
    func unknown() {
        #expect(SchoolEventKind(raw: "carnival") == .other)
        #expect(SchoolEventKind(raw: nil) == .other)
    }
}
