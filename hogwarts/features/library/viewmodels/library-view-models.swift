import Foundation
import Observation

@MainActor
@Observable
final class BookCatalogViewModel {
    private let actions = LibraryActions()
    var tenantContext: TenantContext?

    var books: [Book] = []
    var category: BookCategory? = nil
    var searchText: String = ""
    var isLoading: Bool = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        error = nil
        do {
            books = try await actions.listBooks(schoolId: schoolId, category: category, search: searchText)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}

@MainActor
@Observable
final class BookDetailViewModel {
    private let actions = LibraryActions()
    var tenantContext: TenantContext?

    var book: Book?
    var isLoading: Bool = false
    var isBorrowing: Bool = false
    var error: String?

    func load(id: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        do {
            book = try await actions.getBook(id: id, schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func borrow() async -> Bool {
        guard let book, let schoolId = tenantContext?.currentSchoolId else { return false }
        isBorrowing = true
        defer { isBorrowing = false }
        do {
            _ = try await actions.borrowBook(bookId: book.id, schoolId: schoolId)
            await load(id: book.id)
            return true
        } catch {
            self.error = error.localizedDescription
            return false
        }
    }
}

@MainActor
@Observable
final class MyBorrowingsViewModel {
    private let actions = LibraryActions()
    var tenantContext: TenantContext?

    var borrowings: [Borrowing] = []
    var isLoading: Bool = false
    var error: String?

    var active: [Borrowing] { borrowings.filter(\.isActive) }
    var overdue: [Borrowing] { borrowings.filter(\.isOverdue) }
    var history: [Borrowing] { borrowings.filter { $0.status == .returned } }

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        do {
            borrowings = try await actions.myBorrowings(schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func returnBook(_ borrowing: Borrowing) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        do {
            _ = try await actions.returnBook(borrowingId: borrowing.id, schoolId: schoolId)
            await load()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
