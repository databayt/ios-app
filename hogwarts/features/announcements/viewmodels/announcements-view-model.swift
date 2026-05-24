import Foundation
import SwiftUI

// MARK: - AnnouncementsViewModel
//
// Owns the announcements list state + filter selection. Mirrors Android's
// `AnnouncementsViewModel` but uses `@Observable` + async/await instead of
// StateFlow + Hilt.

@MainActor
@Observable
final class AnnouncementsViewModel {
    private(set) var items: [AnnouncementListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var selectedFilter: AnnouncementsFilter = .all {
        didSet {
            // Filter changes reproject the existing list — no refetch needed
            // because the backend doesn't filter server-side today.
        }
    }

    private let actions: AnnouncementsActions

    init(actions: AnnouncementsActions = .init()) {
        self.actions = actions
    }

    /// Visible items after the current filter is applied.
    var filteredItems: [AnnouncementListItem] {
        switch selectedFilter {
        case .all:
            return items
        case .priority(let kind):
            return items.filter { $0.priorityKind == kind }
        }
    }

    /// Items considered recent (last 48 hours) — surfaces above the rest.
    var recentItems: [AnnouncementListItem] {
        filteredItems.filter(\.isRecent)
    }

    /// Older items grouped together below the recents.
    var olderItems: [AnnouncementListItem] {
        filteredItems.filter { !$0.isRecent }
    }

    /// Initial load + pull-to-refresh entry point.
    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let response = try await actions.list(page: 1, perPage: 20)
            items = response.data
        } catch is CancellationError {
            // View disappeared mid-fetch — keep prior items visible.
        } catch {
            lastError = error.localizedDescription
            // Preserve prior items so the list doesn't blank on transient errors.
        }
    }
}

// MARK: - Filter

enum AnnouncementsFilter: Hashable {
    case all
    case priority(AnnouncementPriority)

    var label: LocalizedStringResource {
        switch self {
        case .all:
            return "announcements.filter.all"
        case .priority(let kind):
            return kind.label
        }
    }

    static let allCases: [AnnouncementsFilter] = [
        .all,
        .priority(.high),
        .priority(.medium),
        .priority(.low),
    ]
}
