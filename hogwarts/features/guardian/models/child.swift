import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/guardian/children` (list) and
// `/api/mobile/guardian/children/:childId` (detail). Detail adds the
// admission/contact metadata the list view doesn't need.

struct ChildListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let givenName: String
    let familyName: String
    let gender: String?
    let dateOfBirth: Date?
    let photoUrl: String?
    let status: String?
    let relationship: String?
    let section: String?
    let grade: String?

    var fullName: String {
        [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }

    /// "Grade 5 · A" — single-line subtitle for the children list card.
    var classLine: String? {
        switch (grade, section) {
        case (let g?, let s?) where !g.isEmpty && !s.isEmpty: return "\(g) · \(s)"
        case (let g?, _) where !g.isEmpty: return g
        case (_, let s?) where !s.isEmpty: return s
        default: return nil
        }
    }
}

struct ChildrenListResponse: Codable, Sendable {
    let data: [ChildListItem]
}

struct ChildDetail: Codable, Identifiable, Sendable {
    let id: String
    let givenName: String
    let familyName: String
    let grNumber: String?
    let studentId: String?
    let gender: String?
    let dateOfBirth: Date?
    let nationality: String?
    let bloodGroup: String?
    let status: String?
    let photoUrl: String?
    let email: String?
    let phone: String?
    let enrollmentDate: Date?
    let admissionNumber: String?
    let section: ChildSection?

    var fullName: String {
        [givenName, familyName].filter { !$0.isEmpty }.joined(separator: " ")
    }
}

struct ChildSection: Codable, Hashable, Sendable, Identifiable {
    let id: String
    let name: String
    let grade: String?
}
