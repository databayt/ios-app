import Foundation
import SwiftUI

/// `/lumos/courses`: one browse read per grade, and a search that replaces the
/// browse with a paginated grid until it is cleared.
///
/// The numbers are the web's: the shelf leads with `RECOMMENDED_COUNT` courses,
/// the grid shows `OTHERS_PAGE_SIZE` more each "see more", and the sheet's
/// typeahead waits 250ms and asks for six.
@MainActor
@Observable
final class LumosCoursesViewModel {
    static let recommendedCount = 6
    static let othersPageSize = 12
    private static let minQueryLength = 2
    private static let suggestionLimit = 6
    private static let featuredLimit = 6

    private(set) var page: LumosCoursesPage?
    private(set) var isLoading = true
    private(set) var lastError: String?

    /// The grade the reader picked; nil lets the server choose.
    private(set) var level: Int?

    /// The submitted search — non-empty leaves the browse view for the grid.
    private(set) var searchQuery = ""
    private(set) var searchResults: [CatalogCourse] = []
    private(set) var searchTotal = 0
    private(set) var isSearching = false

    /// Typeahead inside the sheet, before anything is submitted.
    private(set) var typeahead: [CatalogCourse] = []
    private(set) var isLoadingSuggestions = false
    private(set) var featured: [CatalogCourse] = []

    private let actions: LumosActions
    private var searchTask: Task<Void, Never>?
    private var suggestionCache: [String: [CatalogCourse]] = [:]
    private var featuredFor: Int?? = .some(nil)

    init(actions: LumosActions = .init()) {
        self.actions = actions
    }

    // MARK: - Browse

    /// Every course of the grade the page is showing.
    var courses: [CatalogCourse] {
        page?.shelves.first(where: { $0.grade == effectiveGrade })?.courses
            ?? page?.shelves.flatMap(\.courses)
            ?? []
    }

    /// The shelf the grade leads with, before the grid of the rest.
    var recommended: [CatalogCourse] {
        Array(courses.prefix(Self.recommendedCount))
    }

    /// Everything the shelf does not lead with.
    var others: [CatalogCourse] {
        Array(courses.dropFirst(Self.recommendedCount))
    }

    var visibleOthers: [CatalogCourse] {
        Array(others.prefix(visibleOthersCount))
    }

    private var visibleOthersCount = LumosCoursesViewModel.othersPageSize

    var hasMoreOthers: Bool {
        visibleOthersCount < others.count
    }

    /// The grade the page is showing: the reader's pick, else the server's.
    var effectiveGrade: Int? {
        level ?? page?.effectiveGrade ?? page?.recommendedGrade
    }

    func loadBrowse() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            page = try await actions.coursesPage(level: level)
            visibleOthersCount = Self.othersPageSize
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    func selectGrade(_ grade: Int) {
        guard grade != level else { return }
        level = grade
        clearSearch()
        Task { await loadBrowse() }
    }

    func seeMoreOthers() {
        visibleOthersCount += Self.othersPageSize
    }

    // MARK: - Search

    func submitSearch(_ query: String) async {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return clearSearch() }
        searchQuery = term
        isSearching = true
        lastError = nil
        defer { isSearching = false }
        do {
            let result = try await actions.search(query: term, perPage: Self.othersPageSize)
            searchResults = result.courses
            searchTotal = result.total
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    func clearSearch() {
        searchTask?.cancel()
        searchQuery = ""
        searchResults = []
        searchTotal = 0
        typeahead = []
        isLoadingSuggestions = false
    }

    /// Typing: two characters or more, answered after a 250ms pause, cached
    /// per query so backspacing costs nothing.
    func onTypeahead(_ query: String) {
        searchTask?.cancel()
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard term.count >= Self.minQueryLength else {
            typeahead = []
            isLoadingSuggestions = false
            return
        }
        let key = term.lowercased()
        if let cached = suggestionCache[key] {
            typeahead = cached
            isLoadingSuggestions = false
            return
        }
        isLoadingSuggestions = true
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(250))
            guard !Task.isCancelled, let self else { return }
            do {
                let result = try await self.actions.search(query: term, perPage: Self.suggestionLimit)
                guard !Task.isCancelled else { return }
                self.suggestionCache[key] = result.courses
                self.typeahead = result.courses
            } catch {
                guard !Task.isCancelled else { return }
                self.typeahead = []
            }
            self.isLoadingSuggestions = false
        }
    }

    /// The sheet's empty face: its shelf, read once per grade the sheet opens
    /// on — eighteen rows asked for, six distinct titles kept.
    func sheetOpened() async {
        if featuredFor == .some(level), !featured.isEmpty { return }
        featuredFor = .some(level)
        do {
            let result = try await actions.search(grade: level, perPage: Self.featuredLimit * 3)
            var seen = Set<String>()
            featured = result.courses
                .filter { seen.insert($0.title.trimmingCharacters(in: .whitespaces).lowercased()).inserted }
                .prefix(Self.featuredLimit)
                .map { $0 }
        } catch {
            featuredFor = .some(nil)
        }
    }
}
