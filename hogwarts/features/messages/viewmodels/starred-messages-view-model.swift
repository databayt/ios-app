import Foundation
import SwiftUI

@MainActor
@Observable
final class StarredMessagesViewModel {
    private(set) var items: [StarredMessage] = []
    private(set) var searchHits: [MessageSearchHit] = []
    private(set) var isLoading = false
    private(set) var isSearching = false
    private(set) var lastError: String?
    var query: String = "" {
        didSet { scheduleSearch() }
    }

    private let actions: StarredMessagesActions
    private var searchTask: Task<Void, Never>?

    init(actions: StarredMessagesActions = .init()) {
        self.actions = actions
    }

    func loadStarred() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            items = try await actions.list().data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Debounce search input ~250 ms so we don't hammer the backend on
    /// every keystroke. Each call cancels the previous in-flight task.
    private func scheduleSearch() {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            searchHits = []
            return
        }
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(250))
            guard let self, !Task.isCancelled else { return }
            await self.runSearch(trimmed)
        }
    }

    private func runSearch(_ query: String) async {
        isSearching = true
        defer { isSearching = false }
        do {
            searchHits = try await actions.search(query: query).data
        } catch is CancellationError {
            // ignore — stale request
        } catch {
            lastError = error.localizedDescription
            searchHits = []
        }
    }
}
