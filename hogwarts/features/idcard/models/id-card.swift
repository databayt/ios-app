import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/idcard`. The backend composes from User + Student
// (or Teacher / Staff) + School records, returning a single `IDCardResponse`
// shape that the iOS card view renders directly.

struct IDCardResponse: Codable, Sendable {
    let user: IDCardUser
    let school: IDCardSchool?
}

struct IDCardUser: Codable, Sendable, Identifiable {
    let id: String
    let givenName: String
    let familyName: String
    let email: String?
    let role: String
    let photoUrl: String?
    let idNumber: String?
    let bloodGroup: String?
    let section: String?
    let grade: String?
    let department: String?
    let position: String?

    var fullName: String {
        [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var roleKind: UserRole {
        UserRole(rawValue: role) ?? .user
    }

    /// Subtitle line under the name — varies by role.
    var subtitle: String {
        if let position, !position.isEmpty { return position }
        if let department, !department.isEmpty { return department }
        if let grade, !grade.isEmpty {
            if let section, !section.isEmpty {
                return "\(grade) · \(section)"
            }
            return grade
        }
        return roleKind.displayName
    }
}

struct IDCardSchool: Codable, Sendable, Identifiable {
    let id: String
    let name: String
    let nameEn: String?
    let logoUrl: String?
    let address: String?
    let phone: String?
    let email: String?
    let website: String?

    /// Returns the school name in the active locale's preferred language —
    /// falls back to the canonical `name` when an English variant isn't set.
    func displayName(for locale: Locale) -> String {
        let isEnglish = (locale.language.languageCode?.identifier ?? "ar") == "en"
        if isEnglish, let en = nameEn, !en.isEmpty { return en }
        return name
    }
}
