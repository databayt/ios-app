import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/admin/stats`, `/staff`, `/classes`, `/school`.
// `stats` is a single object the dashboard reads; the rest are paginated.

struct AdminStats: Codable, Sendable {
    let totalStudents: Int
    let totalTeachers: Int
    let totalGuardians: Int
    let totalSections: Int
    let todayAttendanceCount: Int
    let todayPresentCount: Int
    /// Percent 0-100, one decimal of precision (backend already rounds).
    let todayAttendanceRate: Double
    let upcomingExams: Int
    let unreadNotifications: Int
    let activeConversations: Int
}

struct AdminSchool: Codable, Sendable, Identifiable {
    let id: String
    let name: String
    let nameEn: String?
    let domain: String?
    let totalStudents: Int
    let totalTeachers: Int
    let totalSections: Int

    func displayName(for locale: Locale) -> String {
        let isEnglish = (locale.language.languageCode?.identifier ?? "ar") == "en"
        if isEnglish, let en = nameEn, !en.isEmpty { return en }
        return name
    }
}

struct AdminStaffMember: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let givenName: String
    let familyName: String
    let email: String?
    let role: String?
    let status: String?
    let photoUrl: String?
    let employeeId: String?
    let department: String?
    let position: String?
    let subject: String?

    var fullName: String {
        [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var roleKind: AdminStaffRole {
        AdminStaffRole(raw: role)
    }
}

struct AdminStaffResponse: Codable, Sendable {
    let data: [AdminStaffMember]
    let total: Int
    let totalTeachers: Int?
    let totalStaff: Int?
    let page: Int
    let perPage: Int
}

struct AdminClass: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let letter: String?
    let maxCapacity: Int?
    let studentCount: Int
    let grade: AdminGradeRef?
    let homeroomTeacher: AdminTeacherRef?
    let classroom: AdminClassroomRef?
}

struct AdminGradeRef: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
    let number: Int?
}

struct AdminTeacherRef: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
}

struct AdminClassroomRef: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
}

struct AdminClassesResponse: Codable, Sendable {
    let data: [AdminClass]
    let total: Int
    let page: Int
    let perPage: Int
}

// MARK: - Domain enums

enum AdminStaffRole: String, CaseIterable, Sendable, Hashable {
    case teacher
    case staff
    case unknown

    init(raw: String?) {
        switch raw?.uppercased() {
        case "TEACHER": self = .teacher
        case "STAFF":   self = .staff
        default:        self = .unknown
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .teacher: "admin.role.teacher"
        case .staff:   "admin.role.staff"
        case .unknown: "admin.role.unknown"
        }
    }

    var color: Color {
        switch self {
        case .teacher: .accentPurple
        case .staff:   .accentBlue
        case .unknown: .appleGray1
        }
    }
}

enum AdminStaffFilter: Hashable, CaseIterable {
    case all
    case teachers
    case staff

    var apiParam: String? {
        switch self {
        case .all: nil
        case .teachers: "teacher"
        case .staff: "staff"
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .all:      "admin.staff.filter.all"
        case .teachers: "admin.staff.filter.teachers"
        case .staff:    "admin.staff.filter.staff"
        }
    }
}
