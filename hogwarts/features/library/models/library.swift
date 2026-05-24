import Foundation

enum BookCategory: String, Codable, CaseIterable, Identifiable {
    case fiction
    case nonFiction = "non_fiction"
    case science
    case mathematics
    case history
    case literature
    case reference
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fiction:     String(localized: "library.category.fiction")
        case .nonFiction:  String(localized: "library.category.non_fiction")
        case .science:     String(localized: "library.category.science")
        case .mathematics: String(localized: "library.category.mathematics")
        case .history:     String(localized: "library.category.history")
        case .literature:  String(localized: "library.category.literature")
        case .reference:   String(localized: "library.category.reference")
        case .other:       String(localized: "library.category.other")
        }
    }
}

struct Book: Codable, Equatable, Identifiable {
    let id: String
    let title: String
    let author: String
    let isbn: String
    let category: BookCategory
    let description: String
    let coverImageUrl: String?
    let availableCopies: Int
    let totalCopies: Int
    let shelfLocation: String
    let sectionName: String

    var isAvailable: Bool { availableCopies > 0 }
}

enum BorrowingStatus: String, Codable {
    case active
    case returned
    case overdue
    case renewed

    var displayName: String {
        switch self {
        case .active:   String(localized: "library.status.active")
        case .returned: String(localized: "library.status.returned")
        case .overdue:  String(localized: "library.status.overdue")
        case .renewed:  String(localized: "library.status.renewed")
        }
    }
}

struct Borrowing: Codable, Equatable, Identifiable {
    let id: String
    let bookId: String
    let bookTitle: String
    let userId: String
    let borrowedDate: Date
    let dueDate: Date
    let returnedDate: Date?
    let status: BorrowingStatus
    let fine: Double?

    var isOverdue: Bool { status == .overdue }
    var isActive: Bool { status == .active || status == .renewed }
}
