import Foundation
import SwiftUI

@MainActor
@Observable
final class EventsViewModel {
    private(set) var items: [SchoolEventListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var filter: EventsFilter = .upcoming

    private let actions: EventsActions

    init(actions: EventsActions = .init()) {
        self.actions = actions
    }

    var upcomingItems: [SchoolEventListItem] {
        items.filter(\.isUpcoming).sorted { ($0.startDate ?? .distantPast) < ($1.startDate ?? .distantPast) }
    }

    var pastItems: [SchoolEventListItem] {
        items.filter { !$0.isUpcoming }.sorted { ($0.startDate ?? .distantPast) > ($1.startDate ?? .distantPast) }
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            // Always fetch a wider window so users can switch the filter
            // chip without a refetch — the projection happens client-side.
            let response = try await actions.list(upcoming: false, page: 1, perPage: 50)
            items = response.data
        } catch is CancellationError {
            // Ignore — view disappeared mid-fetch.
        } catch {
            lastError = error.localizedDescription
        }
    }
}

enum EventsFilter: Hashable, CaseIterable {
    case upcoming
    case past
    case all

    var label: LocalizedStringResource {
        switch self {
        case .upcoming: "events.filter.upcoming"
        case .past:     "events.filter.past"
        case .all:      "events.filter.all"
        }
    }
}
