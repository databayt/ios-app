import Foundation
import Testing
@testable import Hogwarts

@Suite("FeesViewModel")
@MainActor
struct FeesViewModelTests {

    @Test("Status filter narrows the list")
    func statusFilter() {
        let vm = FeesViewModel()
        vm._setItemsForTests(Self.sampleItems)
        vm.statusFilter = .paid
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.statusKind == .paid)
    }

    @Test("count(for:) returns the right counts per status")
    func countsByStatus() {
        let vm = FeesViewModel()
        vm._setItemsForTests(Self.sampleItems)
        #expect(vm.count(for: .paid) == 1)
        #expect(vm.count(for: .pending) == 1)
        #expect(vm.count(for: .overdue) == 1)
        #expect(vm.count(for: nil) == 3)
    }

    private static let sampleItems: [FeeRecord] = [
        FeeRecord(id: "1", feeType: "Tuition", amount: 100, paidAmount: 100,
                  dueDate: nil, paymentDate: Date(), paymentMethod: nil,
                  status: "PAID", lateFee: nil, discount: nil,
                  receiptNumber: nil, remarks: nil),
        FeeRecord(id: "2", feeType: "Books", amount: 50, paidAmount: 0,
                  dueDate: Date(), paymentDate: nil, paymentMethod: nil,
                  status: "PENDING", lateFee: nil, discount: nil,
                  receiptNumber: nil, remarks: nil),
        FeeRecord(id: "3", feeType: "Trip", amount: 30, paidAmount: 0,
                  dueDate: Date(timeIntervalSinceNow: -86_400 * 3),
                  paymentDate: nil, paymentMethod: nil,
                  status: "OVERDUE", lateFee: 5, discount: nil,
                  receiptNumber: nil, remarks: nil),
    ]
}

extension FeesViewModel {
    /// Test-only setter so we don't need to mock the API to drive filter logic.
    func _setItemsForTests(_ records: [FeeRecord]) {
        // Force a Sendable-safe write via the @Observable property setter.
        self.items = records
    }
}

@Suite("FeeRecord")
struct FeeRecordTests {

    @Test("Outstanding amount handles overpayment")
    func outstandingClampsAtZero() {
        let r = FeeRecord(id: "1", feeType: nil, amount: 100, paidAmount: 150,
                          dueDate: nil, paymentDate: nil, paymentMethod: nil,
                          status: "PAID", lateFee: nil, discount: nil,
                          receiptNumber: nil, remarks: nil)
        #expect(r.outstanding == 0)
    }

    @Test("Outstanding includes late fee and subtracts discount")
    func outstandingIncludesLateFeeMinusDiscount() {
        let r = FeeRecord(id: "1", feeType: nil, amount: 100, paidAmount: 50,
                          dueDate: nil, paymentDate: nil, paymentMethod: nil,
                          status: "PARTIAL", lateFee: 10, discount: 5,
                          receiptNumber: nil, remarks: nil)
        // 100 + 10 - 5 - 50 = 55
        #expect(r.outstanding == 55)
    }

    @Test("daysUntilDue is negative when overdue")
    func daysUntilDueOverdue() {
        let now = Date()
        let due = Calendar.current.date(byAdding: .day, value: -3, to: now)!
        let r = FeeRecord(id: "1", feeType: nil, amount: 0, paidAmount: 0,
                          dueDate: due, paymentDate: nil, paymentMethod: nil,
                          status: nil, lateFee: nil, discount: nil,
                          receiptNumber: nil, remarks: nil)
        #expect(r.daysUntilDue(now: now) == -3)
    }
}

@Suite("FeeStatus")
struct FeeStatusTests {

    @Test("Maps backend strings", arguments: [
        ("PAID", FeeStatus.paid),
        ("PENDING", .pending),
        ("PARTIAL", .partial),
        ("OVERDUE", .overdue),
        ("WAIVED", .waived),
    ])
    func mapsCanonicalStrings(raw: String, expected: FeeStatus) {
        #expect(FeeStatus(raw: raw) == expected)
    }

    @Test("Unknown for nil or junk")
    func unknownFallback() {
        #expect(FeeStatus(raw: nil) == .unknown)
        #expect(FeeStatus(raw: "REFUNDED") == .unknown)
    }
}
