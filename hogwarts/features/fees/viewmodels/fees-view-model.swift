import Foundation
import SwiftUI

@MainActor
@Observable
final class FeesViewModel {
    private(set) var items: [FeeRecord] = []
    private(set) var summary: FeeSummary?
    private(set) var isLoading = false
    private(set) var lastError: String?
    var statusFilter: FeeStatus?

    private let actions: FeesActions

    init(actions: FeesActions = .init()) {
        self.actions = actions
    }

    var filteredItems: [FeeRecord] {
        guard let statusFilter else { return items }
        return items.filter { $0.statusKind == statusFilter }
    }

    /// Used to surface the per-status counts on the filter chips.
    func count(for status: FeeStatus?) -> Int {
        guard let status else { return items.count }
        return items.filter { $0.statusKind == status }.count
    }

    func load(studentId: String?) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        // Run list + summary in parallel — summary is best-effort and only
        // possible when we know the student id; if it fails we keep the
        // list visible without the top card.
        async let listTask = actions.list(studentId: studentId, page: 1, perPage: 100)

        do {
            let response = try await listTask
            items = response.data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }

        if let studentId, !studentId.isEmpty {
            do {
                summary = try await actions.summary(studentId: studentId)
            } catch {
                // Non-fatal — keep prior summary if any.
            }
        }
    }
}
