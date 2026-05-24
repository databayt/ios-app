import Foundation
import Testing
@testable import Hogwarts

@Suite("HallPassViewModel")
@MainActor
struct HallPassViewModelTests {

    @Test("filteredItems honors statusFilter")
    func filterByStatus() {
        let vm = HallPassViewModel()
        vm._setItemsForTests(Self.fixtures)
        vm.statusFilter = .overdue
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.statusKind == .overdue)

        vm.statusFilter = nil
        #expect(vm.filteredItems.count == Self.fixtures.count)
    }

    @Test("activeCount counts only ACTIVE")
    func activeCount() {
        let vm = HallPassViewModel()
        vm._setItemsForTests(Self.fixtures)
        #expect(vm.activeCount == 2)
    }

    @Test("overdueCount counts only OVERDUE")
    func overdueCount() {
        let vm = HallPassViewModel()
        vm._setItemsForTests(Self.fixtures)
        #expect(vm.overdueCount == 1)
    }

    private static let fixtures: [HallPass] = [
        pass("1", status: "ACTIVE"),
        pass("2", status: "ACTIVE"),
        pass("3", status: "OVERDUE"),
        pass("4", status: "RETURNED"),
    ]

    private static func pass(_ id: String, status: String) -> HallPass {
        let now = Date()
        return HallPass(
            id: id, studentId: "s\(id)", studentName: "Name",
            classId: nil, destination: "Library", destinationNote: nil,
            issuedBy: nil, issuedAt: now,
            expectedDuration: 10,
            expectedReturn: now.addingTimeInterval(60 * 10),
            returnedAt: nil, status: status
        )
    }
}

extension HallPassViewModel {
    func _setItemsForTests(_ items: [HallPass]) {
        self.items = items
    }
}
