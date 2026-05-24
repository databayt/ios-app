import Foundation
import Testing
@testable import Hogwarts

@Suite("SubjectsViewModel")
@MainActor
struct SubjectsViewModelTests {

    @Test("Departments are deduplicated and sorted")
    func departments() {
        let vm = SubjectsViewModel()
        vm._setItemsForTests(Self.fixtureItems)
        let deps = vm.departments
        // Three unique departments, sorted alphabetically.
        #expect(deps == ["Math", "Science", "Sports"])
    }

    @Test("Catalog scope returns all items")
    func catalogScope() {
        let vm = SubjectsViewModel()
        vm._setItemsForTests(Self.fixtureItems)
        vm._setMineForTests([])
        vm.scope = .catalog
        #expect(vm.filteredItems.count == Self.fixtureItems.count)
    }

    @Test("Mine scope intersects with mySubjects ids")
    func mineScope() {
        let vm = SubjectsViewModel()
        vm._setItemsForTests(Self.fixtureItems)
        vm._setMineForTests([
            MySubjectsListItem(id: "math-1", name: "Algebra",
                               slug: nil, department: nil, thumbnailUrl: nil)
        ])
        vm.scope = .mine
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.id == "math-1")
    }

    @Test("Search narrows by name or department substring")
    func search() {
        let vm = SubjectsViewModel()
        vm._setItemsForTests(Self.fixtureItems)
        vm.scope = .catalog
        vm.search = "alge"
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Algebra")
        vm.search = "scien"
        #expect(vm.filteredItems.contains(where: { $0.name == "Biology" }))
    }

    @Test("Department filter restricts to that department")
    func departmentFilter() {
        let vm = SubjectsViewModel()
        vm._setItemsForTests(Self.fixtureItems)
        vm.scope = .catalog
        vm.selectedDepartment = "Math"
        #expect(vm.filteredItems.allSatisfy { $0.department == "Math" })
    }

    private static let fixtureItems: [CatalogSubjectListItem] = [
        item(id: "math-1", name: "Algebra", department: "Math"),
        item(id: "math-2", name: "Geometry", department: "Math"),
        item(id: "sci-1",  name: "Biology", department: "Science"),
        item(id: "spt-1",  name: "Football", department: "Sports"),
    ]

    private static func item(id: String, name: String, department: String) -> CatalogSubjectListItem {
        CatalogSubjectListItem(
            id: id, name: name, slug: nil, department: department,
            description: nil, thumbnailUrl: nil, color: nil,
            levels: nil, grades: nil,
            totalChapters: nil, totalLessons: nil,
            averageRating: nil, ratingCount: nil
        )
    }
}

extension SubjectsViewModel {
    /// Test-only setters for deterministic state without network mocks.
    func _setItemsForTests(_ items: [CatalogSubjectListItem]) {
        self.allItems = items
    }
    func _setMineForTests(_ mine: [MySubjectsListItem]) {
        self.mySubjects = mine
    }
}

@Suite("CatalogSubjectListItem display helpers")
struct CatalogSubjectDisplayTests {

    @Test("Level badge capitalizes first level")
    func levelBadge() {
        let item = CatalogSubjectListItem(
            id: "x", name: "X", slug: nil, department: nil, description: nil,
            thumbnailUrl: nil, color: nil, levels: ["primary", "secondary"],
            grades: nil, totalChapters: nil, totalLessons: nil,
            averageRating: nil, ratingCount: nil
        )
        #expect(item.levelBadge == "Primary")
    }

    @Test("Grade badge formats single vs range")
    func gradeBadge() {
        let single = CatalogSubjectListItem(
            id: "x", name: "X", slug: nil, department: nil, description: nil,
            thumbnailUrl: nil, color: nil, levels: nil, grades: ["5"],
            totalChapters: nil, totalLessons: nil,
            averageRating: nil, ratingCount: nil
        )
        #expect(single.gradeBadge == "G5")

        let range = CatalogSubjectListItem(
            id: "x", name: "X", slug: nil, department: nil, description: nil,
            thumbnailUrl: nil, color: nil, levels: nil, grades: ["3", "4", "5"],
            totalChapters: nil, totalLessons: nil,
            averageRating: nil, ratingCount: nil
        )
        #expect(range.gradeBadge == "G3–5")
    }

    @Test("Grade badge nil when grades empty")
    func gradeBadgeNil() {
        let item = CatalogSubjectListItem(
            id: "x", name: "X", slug: nil, department: nil, description: nil,
            thumbnailUrl: nil, color: nil, levels: nil, grades: [],
            totalChapters: nil, totalLessons: nil,
            averageRating: nil, ratingCount: nil
        )
        #expect(item.gradeBadge == nil)
    }
}

@Suite("Locale.subjectsApiLanguageCode")
struct LocaleApiLanguageTests {

    @Test("Strips region from BCP-47", arguments: ["en-US", "ar-SA", "fr-FR"])
    func stripsRegion(_ id: String) {
        let locale = Locale(identifier: id)
        let code = locale.subjectsApiLanguageCode
        // First two chars should be the language code.
        #expect(code == String(id.prefix(2)))
    }
}
