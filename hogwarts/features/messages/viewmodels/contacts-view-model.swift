import Foundation
import SwiftUI

@MainActor
@Observable
final class ContactsViewModel {
    private(set) var groups: [ContactGroup] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var search: String = "" {
        didSet { scheduleSearch() }
    }
    var selectedCategory: ContactCategory?

    private let actions: ContactsActions
    private var searchTask: Task<Void, Never>?

    init(actions: ContactsActions = .init()) {
        self.actions = actions
    }

    /// Total count for the header subtitle.
    var totalCount: Int {
        groups.reduce(0) { $0 + $1.contacts.count }
    }

    /// Visible groups after the category filter is applied. Search is
    /// server-side, so once it completes the backend already filtered.
    var visibleGroups: [ContactGroup] {
        guard let cat = selectedCategory else { return groups }
        return groups.filter { $0.categoryKind == cat }
    }

    func load(locale: Locale) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            let response = try await actions.list(
                search: search.isEmpty ? nil : search,
                category: nil,
                locale: locale.subjectsApiLanguageCode
            )
            groups = response.groups
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Debounce search input ~300 ms — server-side filter, so this also
    /// reduces network chatter.
    private func scheduleSearch() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard let self, !Task.isCancelled else { return }
            // Search uses the env locale captured by the view.
            await self.load(locale: .current)
        }
    }
}
