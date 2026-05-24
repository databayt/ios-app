import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/teacher/classes` (list of section+subject pairs the
// teacher is timetabled for) and `/api/mobile/teacher/schedule` (weekly
// schedule slots for the teacher).

struct TeacherClass: Codable, Identifiable, Hashable, Sendable {
    var id: String { sectionId + (subjectName ?? "") }
    let sectionId: String
    let sectionName: String
    let gradeName: String?
    let subjectName: String?
    let studentCount: Int

    var displayName: String {
        if let grade = gradeName, let subject = subjectName {
            return "\(grade) · \(sectionName) — \(subject)"
        }
        if let subject = subjectName { return "\(sectionName) — \(subject)" }
        return sectionName
    }
}

struct TeacherClassesResponse: Codable, Sendable {
    let data: [TeacherClass]
}

struct TeacherScheduleSlot: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let dayOfWeek: Int
    let subjectName: String?
    let sectionName: String?
    let gradeName: String?
    let classroom: String?
    let periodName: String?
    let startTime: String?
    let endTime: String?

    /// Matches Calendar.weekdaySymbols indexing — backend uses 0=Sunday.
    var weekdayLabel: LocalizedStringResource {
        switch dayOfWeek {
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

struct TeacherScheduleResponse: Codable, Sendable {
    let data: [TeacherScheduleSlot]
}
