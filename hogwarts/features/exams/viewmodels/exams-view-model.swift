import Foundation
import SwiftUI

@MainActor
@Observable
final class ExamsViewModel {
    private(set) var items: [SchoolExamListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var filter: ExamsFilter = .upcoming

    private let actions: ExamsActions

    init(actions: ExamsActions = .init()) {
        self.actions = actions
    }

    var upcomingItems: [SchoolExamListItem] {
        items.filter(\.isUpcoming).sorted {
            ($0.examDate ?? .distantPast) < ($1.examDate ?? .distantPast)
        }
    }

    var pastItems: [SchoolExamListItem] {
        items.filter { !$0.isUpcoming }.sorted {
            ($0.examDate ?? .distantPast) > ($1.examDate ?? .distantPast)
        }
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            // Fetch wider window so the filter chip is a client-side projection.
            let response = try await actions.list(upcoming: false, page: 1, perPage: 60)
            items = response.data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

enum ExamsFilter: Hashable, CaseIterable {
    case upcoming
    case past
    case all

    var label: LocalizedStringResource {
        switch self {
        case .upcoming: "exams.filter.upcoming"
        case .past:     "exams.filter.past"
        case .all:      "exams.filter.all"
        }
    }
}
