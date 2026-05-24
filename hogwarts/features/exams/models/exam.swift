import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/exams` (list) and `/api/mobile/exams/:id` (detail).
// Detail adds proctor mode, shuffle, max attempts; list omits those.

struct SchoolExamListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let description: String?
    let examDate: Date?
    let startTime: String?
    let endTime: String?
    let duration: Int?
    let totalMarks: Int?
    let passingMarks: Int?
    let examType: String?
    let status: String?
    let instructions: String?
    let subjectName: String?

    var typeKind: SchoolExamType { SchoolExamType(raw: examType) }
    var statusKind: SchoolExamStatus { SchoolExamStatus(raw: status) }

    /// True when the exam is scheduled today or later.
    var isUpcoming: Bool {
        guard let examDate else { return false }
        return examDate >= Calendar.current.startOfDay(for: .now)
    }

    /// Human friendly duration ("60 min" or "1 h 30 min").
    var formattedDuration: String? {
        guard let duration, duration > 0 else { return nil }
        let h = duration / 60
        let m = duration % 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(duration) min"
    }
}

struct SchoolExamsListResponse: Codable, Sendable {
    let data: [SchoolExamListItem]
    let total: Int
    let page: Int
    let perPage: Int
}

struct SchoolExamDetail: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let description: String?
    let examDate: Date?
    let startTime: String?
    let endTime: String?
    let duration: Int?
    let totalMarks: Int?
    let passingMarks: Int?
    let examType: String?
    let status: String?
    let instructions: String?
    let proctorMode: String?
    let shuffleQuestions: Bool?
    let maxAttempts: Int?
    let subjectName: String?

    var typeKind: SchoolExamType { SchoolExamType(raw: examType) }
    var statusKind: SchoolExamStatus { SchoolExamStatus(raw: status) }

    var formattedDuration: String? {
        guard let duration, duration > 0 else { return nil }
        let h = duration / 60
        let m = duration % 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(duration) min"
    }

    /// Pass mark expressed as a percent of total marks.
    var passingPercent: Double? {
        guard let total = totalMarks, total > 0,
              let passing = passingMarks else { return nil }
        return Double(passing) / Double(total)
    }
}

// MARK: - Domain enums

enum SchoolExamType: String, CaseIterable, Sendable, Hashable {
    case quiz
    case midterm
    case final
    case mock
    case practice
    case other

    init(raw: String?) {
        switch raw?.lowercased() {
        case "quiz":     self = .quiz
        case "midterm":  self = .midterm
        case "final":    self = .final
        case "mock":     self = .mock
        case "practice": self = .practice
        default:         self = .other
        }
    }

    var color: Color {
        switch self {
        case .quiz:     .accentBlue
        case .midterm:  .accentOrange
        case .final:    .accentRed
        case .mock:     .accentPurple
        case .practice: .accentGreen
        case .other:    .appleGray1
        }
    }

    var systemImage: String {
        switch self {
        case .quiz:     "checkmark.bubble"
        case .midterm:  "doc.text"
        case .final:    "graduationcap.fill"
        case .mock:     "wand.and.stars"
        case .practice: "pencil.and.outline"
        case .other:    "doc"
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .quiz:     "exams.type.quiz"
        case .midterm:  "exams.type.midterm"
        case .final:    "exams.type.final"
        case .mock:     "exams.type.mock"
        case .practice: "exams.type.practice"
        case .other:    "exams.type.other"
        }
    }
}

enum SchoolExamStatus: String, CaseIterable, Sendable, Hashable {
    case scheduled
    case inProgress
    case completed
    case cancelled
    case unknown

    init(raw: String?) {
        switch raw?.uppercased() {
        case "SCHEDULED":   self = .scheduled
        case "IN_PROGRESS": self = .inProgress
        case "COMPLETED":   self = .completed
        case "CANCELLED":   self = .cancelled
        default:            self = .unknown
        }
    }

    var color: Color {
        switch self {
        case .scheduled:  .accentBlue
        case .inProgress: .accentGreen
        case .completed:  .appleGray1
        case .cancelled:  .accentRed
        case .unknown:    .appleGray1
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .scheduled:  "exams.status.scheduled"
        case .inProgress: "exams.status.inProgress"
        case .completed:  "exams.status.completed"
        case .cancelled:  "exams.status.cancelled"
        case .unknown:    "exams.status.unknown"
        }
    }
}
