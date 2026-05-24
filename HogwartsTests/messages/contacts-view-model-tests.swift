import Foundation
import Testing
@testable import Hogwarts

@Suite("ContactsViewModel")
@MainActor
struct ContactsViewModelTests {

    @Test("totalCount sums across all groups")
    func totalCount() {
        let vm = ContactsViewModel()
        vm._setGroupsForTests(Self.groups)
        #expect(vm.totalCount == 4)
    }

    @Test("visibleGroups returns all when no category filter")
    func visibleAll() {
        let vm = ContactsViewModel()
        vm._setGroupsForTests(Self.groups)
        vm.selectedCategory = nil
        #expect(vm.visibleGroups.count == 2)
    }

    @Test("visibleGroups narrows to selected category")
    func visibleByCategory() {
        let vm = ContactsViewModel()
        vm._setGroupsForTests(Self.groups)
        vm.selectedCategory = .teachers
        #expect(vm.visibleGroups.count == 1)
        #expect(vm.visibleGroups.first?.categoryKind == .teachers)
    }

    private static let groups: [ContactGroup] = [
        ContactGroup(category: "teachers", contacts: [
            contact("t1"), contact("t2"), contact("t3"),
        ]),
        ContactGroup(category: "students", contacts: [
            contact("s1"),
        ]),
    ]

    private static func contact(_ id: String) -> Contact {
        Contact(
            id: id, firstName: "First", lastName: "Last",
            displayName: "First Last",
            email: nil, image: nil, role: nil,
            category: nil, contextLabel: nil
        )
    }
}

extension ContactsViewModel {
    func _setGroupsForTests(_ groups: [ContactGroup]) {
        self.groups = groups
    }
}

@Suite("Contact.fullName")
struct ContactFullNameTests {

    @Test("Prefers displayName when present")
    func displayNameWins() {
        let c = Contact(id: "1", firstName: "A", lastName: "B",
                        displayName: "Custom Display",
                        email: nil, image: nil, role: nil,
                        category: nil, contextLabel: nil)
        #expect(c.fullName == "Custom Display")
    }

    @Test("Falls back to first + last when display is empty")
    func compositeFallback() {
        let c = Contact(id: "1", firstName: "Ahmed", lastName: "Hassan",
                        displayName: "",
                        email: nil, image: nil, role: nil,
                        category: nil, contextLabel: nil)
        #expect(c.fullName == "Ahmed Hassan")
    }

    @Test("Drops nil pieces cleanly")
    func dropsNil() {
        let c = Contact(id: "1", firstName: "Ahmed", lastName: nil,
                        displayName: nil,
                        email: nil, image: nil, role: nil,
                        category: nil, contextLabel: nil)
        #expect(c.fullName == "Ahmed")
    }
}

@Suite("ContactCategory")
struct ContactCategoryTests {

    @Test("Maps backend strings", arguments: [
        ("teachers", ContactCategory.teachers),
        ("students", .students),
        ("parents", .parents),
        ("staff", .staff),
        ("admin", .admin),
        ("accountants", .accountants),
        ("my_students", .mySonStudents),
        ("my_teachers", .myTeachers),
        ("classmates", .classmates),
        ("my_children_teachers", .myChildrenTeachers),
    ])
    func mapsCanonical(raw: String, expected: ContactCategory) {
        #expect(ContactCategory(raw: raw) == expected)
    }

    @Test("Unknown for junk")
    func unknown() {
        #expect(ContactCategory(raw: "principals") == .unknown)
    }
}
