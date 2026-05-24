import Foundation
import SwiftUI

@MainActor
@Observable
final class ReportCardsViewModel {
    private(set) var items: [ReportCardListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: ReportCardsActions

    init(actions: ReportCardsActions = .init()) {
        self.actions = actions
    }

    func load(studentId: String? = nil) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            items = try await actions.list(studentId: studentId, page: 1, perPage: 50).data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
