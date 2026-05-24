import Foundation
import SwiftUI

@MainActor
@Observable
final class SubjectsViewModel {
    private(set) var allItems: [CatalogSubjectListItem] = []
    private(set) var mySubjects: [MySubjectsListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var search: String = ""
    var selectedDepartment: String?
    /// View toggle — "Mine" defaults for students/teachers; admins land on Catalog.
    var scope: SubjectsScope = .catalog

    private let actions: SubjectsActions

    init(actions: SubjectsActions = .init()) {
        self.actions = actions
    }

    /// Distinct list of departments derived from the catalog payload —
    /// surfaced as filter chips above the grid.
    var departments: [String] {
        Array(Set(allItems.compactMap(\.department))).sorted()
    }

    /// Items shown in the current scope, after the search / department filter.
    var filteredItems: [CatalogSubjectListItem] {
        let source: [CatalogSubjectListItem] = {
            switch scope {
            case .catalog: return allItems
            case .mine:
                let mineIDs = Set(mySubjects.map(\.id))
                return allItems.filter { mineIDs.contains($0.id) }
            }
        }()

        return source.filter { item in
            if let dep = selectedDepartment, dep != item.department { return false }
            if !search.isEmpty {
                let needle = search.lowercased()
                let haystack = (item.name + " " + (item.department ?? "")).lowercased()
                if !haystack.contains(needle) { return false }
            }
            return true
        }
    }

    func load(locale: Locale) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        // Fetch the full catalog server-side filterless — local search /
        // department filtering is plenty responsive for the catalog sizes
        // schools work with (typically <100 subjects). The backend search
        // remains an option if we ever paginate.
        async let listTask = actions.list(languageCode: locale.subjectsApiLanguageCode)
        async let mineTask: MySubjectsResponse? = {
            do { return try await actions.mySubjects(languageCode: locale.subjectsApiLanguageCode) }
            catch { return nil }
        }()

        do {
            let list = try await listTask
            allItems = list.data
            if let mine = await mineTask {
                mySubjects = mine.data
            }
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

enum SubjectsScope: Hashable, CaseIterable {
    case catalog
    case mine

    var label: LocalizedStringResource {
        switch self {
        case .catalog: "subjects.scope.catalog"
        case .mine: "subjects.scope.mine"
        }
    }
}
