import Foundation
import SwiftUI

@MainActor
@Observable
final class HallPassViewModel {
    private(set) var items: [HallPass] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var statusFilter: HallPassStatus?

    private let actions: HallPassActions

    init(actions: HallPassActions = .init()) {
        self.actions = actions
    }

    var filteredItems: [HallPass] {
        guard let f = statusFilter else { return items }
        return items.filter { $0.statusKind == f }
    }

    var activeCount: Int { items.filter { $0.statusKind == .active }.count }
    var overdueCount: Int { items.filter { $0.statusKind == .overdue }.count }

    func load(studentId: String? = nil) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            items = try await actions.list(studentId: studentId).data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
