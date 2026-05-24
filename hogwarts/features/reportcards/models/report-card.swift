import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/report-cards` (list) and `/api/mobile/report-cards/:id`
// (detail). The list and detail share metadata (term, GPA, rank, attendance,
// comments); the detail adds the per-subject grades array.

struct ReportCardListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let termId: String?
    let termName: String?
    let overallGrade: String?
    let overallGpa: Double?
    let rank: Int?
    let totalStudents: Int?
    let daysPresent: Int?
    let daysAbsent: Int?
    let daysLate: Int?
    let teacherComments: String?
    let principalComments: String?
    let pdfUrl: String?
    let publishedAt: Date?
    let createdAt: Date?

    var attendanceRate: Double? {
        let total = (daysPresent ?? 0) + (daysAbsent ?? 0) + (daysLate ?? 0)
        guard total > 0 else { return nil }
        return Double(daysPresent ?? 0) / Double(total)
    }

    /// Color associated with the overall grade letter (A → green, F → red).
    var gradeColor: Color {
        ReportCardGrade.color(for: overallGrade)
    }
}

struct ReportCardsListResponse: Codable, Sendable {
    let data: [ReportCardListItem]
    let total: Int
    let page: Int
    let perPage: Int
}

struct ReportCardDetail: Codable, Identifiable, Sendable {
    let id: String
    let student: ReportCardStudent
    let termId: String?
    let termName: String?
    let overallGrade: String?
    let overallGpa: Double?
    let rank: Int?
    let totalStudents: Int?
    let daysPresent: Int?
    let daysAbsent: Int?
    let daysLate: Int?
    let teacherComments: String?
    let principalComments: String?
    let pdfUrl: String?
    let isPublished: Bool?
    let publishedAt: Date?
    let createdAt: Date?
    let grades: [ReportCardGradeRow]?

    var attendanceRate: Double? {
        let total = (daysPresent ?? 0) + (daysAbsent ?? 0) + (daysLate ?? 0)
        guard total > 0 else { return nil }
        return Double(daysPresent ?? 0) / Double(total)
    }
}

struct ReportCardStudent: Codable, Sendable, Identifiable {
    let id: String
    let givenName: String
    let familyName: String
    let section: String?
    let grade: String?

    var fullName: String {
        [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }
}

struct ReportCardGradeRow: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let grade: String?
    let score: Double?
    let maxScore: Double?
    let percentage: Double?
    let credits: Double?
    let comments: String?
    let subject: ReportCardSubjectRef?

    var color: Color { ReportCardGrade.color(for: grade) }
}

struct ReportCardSubjectRef: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
}

// MARK: - Grade → color mapping

enum ReportCardGrade {
    static func color(for letter: String?) -> Color {
        switch letter?.uppercased().first {
        case "A": .gradeExcellent
        case "B": .gradeGood
        case "C": .gradeAverage
        case "D": .gradeBelowAverage
        case "F", "E": .gradeFail
        default: .appleGray1
        }
    }
}
