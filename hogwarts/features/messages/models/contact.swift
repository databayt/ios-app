import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/contacts` — returns `{groups: [{category, contacts}]}`.
// Each contact is the minimum needed to start a direct conversation: user
// id + display name + role + optional context (section, department, etc.).

struct ContactGroup: Codable, Identifiable, Hashable, Sendable {
    var id: String { category }
    let category: String
    let contacts: [Contact]

    var categoryKind: ContactCategory { ContactCategory(raw: category) }
}

struct Contact: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let firstName: String?
    let lastName: String?
    let displayName: String?
    let email: String?
    let image: String?
    let role: String?
    let category: String?
    let contextLabel: String?

    var fullName: String {
        if let display = displayName, !display.isEmpty { return display }
        return [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}

struct ContactsResponse: Codable, Sendable {
    let groups: [ContactGroup]
}

// MARK: - Domain enum

enum ContactCategory: String, CaseIterable, Sendable, Hashable {
    case teachers
    case students
    case parents
    case staff
    case admin
    case accountants
    case mySonStudents = "my_students"
    case myTeachers = "my_teachers"
    case classmates
    case myChildrenTeachers = "my_children_teachers"
    case unknown

    init(raw: String) {
        self = ContactCategory(rawValue: raw) ?? .unknown
    }

    var label: LocalizedStringResource {
        switch self {
        case .teachers:           "contacts.cat.teachers"
        case .students:           "contacts.cat.students"
        case .parents:            "contacts.cat.parents"
        case .staff:              "contacts.cat.staff"
        case .admin:              "contacts.cat.admin"
        case .accountants:        "contacts.cat.accountants"
        case .mySonStudents:      "contacts.cat.myStudents"
        case .myTeachers:         "contacts.cat.myTeachers"
        case .classmates:         "contacts.cat.classmates"
        case .myChildrenTeachers: "contacts.cat.myChildrenTeachers"
        case .unknown:            "contacts.cat.other"
        }
    }

    var systemImage: String {
        switch self {
        case .teachers, .myTeachers, .myChildrenTeachers: "person.fill.checkmark"
        case .students, .mySonStudents, .classmates:      "graduationcap.fill"
        case .parents:                                    "person.2.fill"
        case .staff:                                      "person.text.rectangle.fill"
        case .admin:                                      "shield.fill"
        case .accountants:                                "dollarsign.circle.fill"
        case .unknown:                                    "person.crop.circle"
        }
    }

    var color: Color {
        switch self {
        case .teachers, .myTeachers, .myChildrenTeachers: .accentPurple
        case .students, .mySonStudents, .classmates:      .accentBlue
        case .parents:                                    .accentGreen
        case .staff:                                      .accentTeal
        case .admin:                                      .accentRed
        case .accountants:                                .accentOrange
        case .unknown:                                    .appleGray1
        }
    }
}
