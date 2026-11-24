import Foundation
import SwiftUI

/// `/lumos` — the LMS home: what to continue, one shelf per grade, and the
/// single lesson the platform suggests starting with.
@MainActor
@Observable
final class LumosHomeViewModel {
    private(set) var page = LumosCoursesPage()
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: LumosActions

    init(actions: LumosActions = .init()) {
        self.actions = actions
    }

    /// The grade shelves worth showing: a shelf with no courses is noise.
    var shelves: [GradeShelf] {
        page.shelves.filter { !$0.courses.isEmpty }
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            page = try await actions.coursesPage()
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
