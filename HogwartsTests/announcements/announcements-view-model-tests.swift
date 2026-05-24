import Foundation
import Testing
@testable import Hogwarts

@Suite("AnnouncementsViewModel")
@MainActor
struct AnnouncementsViewModelTests {

    // MARK: - Filter

    @Test("All filter returns every item")
    func allFilter() {
        let vm = AnnouncementsViewModel()
        vm.items = Self.sampleItems
        vm.selectedFilter = .all
        #expect(vm.filteredItems.count == vm.items.count)
    }

    @Test("Priority filter narrows to that bucket only")
    func priorityFilter() {
        let vm = AnnouncementsViewModel()
        vm.items = Self.sampleItems
        vm.selectedFilter = .priority(.high)
        #expect(vm.filteredItems.allSatisfy { $0.priorityKind == .high })
        #expect(vm.filteredItems.count == 1)
    }

    // MARK: - Recent vs older

    @Test("Items in last 48 h count as recent")
    func recentBucket() {
        let vm = AnnouncementsViewModel()
        vm.items = Self.sampleItems
        let recent = vm.recentItems
        // The 1-hour-ago and 6-hour-ago items are recent; 5-day-ago is not.
        #expect(recent.contains(where: { $0.id == "1h" }))
        #expect(recent.contains(where: { $0.id == "6h" }))
        #expect(!recent.contains(where: { $0.id == "5d" }))
    }

    @Test("Older bucket excludes recents")
    func olderBucket() {
        let vm = AnnouncementsViewModel()
        vm.items = Self.sampleItems
        #expect(vm.olderItems.allSatisfy { !$0.isRecent })
        #expect(vm.olderItems.contains(where: { $0.id == "5d" }))
    }

    // MARK: - Fixtures

    private static let sampleItems: [AnnouncementListItem] = [
        item(id: "1h", priority: "high",   ago: 60 * 60),
        item(id: "6h", priority: "normal", ago: 60 * 60 * 6),
        item(id: "5d", priority: "low",    ago: 60 * 60 * 24 * 5),
    ]

    private static func item(id: String, priority: String, ago: TimeInterval) -> AnnouncementListItem {
        AnnouncementListItem(
            id: id,
            title: "Title \(id)",
            content: "Content \(id)",
            priority: priority,
            publishedAt: Date(timeIntervalSinceNow: -ago),
            expiresAt: nil,
            authorName: nil,
            authorAvatar: nil
        )
    }
}

@Suite("AnnouncementPriority")
struct AnnouncementPriorityTests {

    @Test("High raw value", arguments: ["high", "HIGH", "urgent", "URGENT"])
    func highSynonyms(_ raw: String) {
        #expect(AnnouncementPriority(raw: raw) == .high)
    }

    @Test("Medium covers normal", arguments: ["normal", "medium", "Normal"])
    func mediumSynonyms(_ raw: String) {
        #expect(AnnouncementPriority(raw: raw) == .medium)
    }

    @Test("Unknown for nil and junk")
    func unknownFallback() {
        #expect(AnnouncementPriority(raw: nil) == .unknown)
        #expect(AnnouncementPriority(raw: "garbled") == .unknown)
    }
}
