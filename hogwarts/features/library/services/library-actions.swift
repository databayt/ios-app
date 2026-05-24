import Foundation

final class LibraryActions: Sendable {
    private let api = APIClient.shared

    func listBooks(schoolId: String, category: BookCategory? = nil, search: String? = nil) async throws -> [Book] {
        var query: [String: String] = [:]
        if let category { query["category"] = category.rawValue }
        if let search, !search.isEmpty { query["q"] = search }
        return try await api.get("/mobile/library/books", query: query, as: [Book].self)
    }

    func getBook(id: String, schoolId: String) async throws -> Book {
        try await api.get("/mobile/library/books/\(id)", as: Book.self)
    }

    func myBorrowings(schoolId: String) async throws -> [Borrowing] {
        try await api.get("/mobile/library/borrowings", as: [Borrowing].self)
    }

    func borrowBook(bookId: String, schoolId: String) async throws -> Borrowing {
        try await api.post("/mobile/library/borrow", body: ["bookId": bookId], as: Borrowing.self)
    }

    func returnBook(borrowingId: String, schoolId: String) async throws -> Borrowing {
        try await api.post("/mobile/library/return", body: ["borrowingId": borrowingId], as: Borrowing.self)
    }
}
