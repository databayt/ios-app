import Foundation
import Testing
@testable import Hogwarts

@Suite("HomeViewModel.project")
struct HomeViewModelProjectTests {

    @Test("Server unread overrides previous")
    func serverUnreadOverrides() {
        let previous = HomeTileBadgeCounts(unreadNotifications: 1)
        let response = makeResponse(unread: 7)
        let projected = HomeViewModel.project(response: response, previous: previous)
        #expect(projected.unreadNotifications == 7)
    }

    @Test("Missing server unread keeps previous")
    func missingUnreadKeepsPrevious() {
        let previous = HomeTileBadgeCounts(unreadNotifications: 4)
        let response = makeResponse(unread: nil)
        let projected = HomeViewModel.project(response: response, previous: previous)
        #expect(projected.unreadNotifications == 4)
    }

    @Test("Counts not in payload are preserved from previous")
    func preservesUnrelatedCounts() {
        let previous = HomeTileBadgeCounts(
            pendingAttendance: 2,
            upcomingExams: 3,
            todayClasses: 5,
            unreadMessages: 8,
            unreadNotifications: 1,
            pendingAssignments: 6
        )
        let response = makeResponse(unread: 9)
        let projected = HomeViewModel.project(response: response, previous: previous)
        #expect(projected.pendingAttendance == 2)
        #expect(projected.upcomingExams == 3)
        #expect(projected.todayClasses == 5)
        #expect(projected.unreadMessages == 8)
        #expect(projected.pendingAssignments == 6)
        #expect(projected.unreadNotifications == 9)  // updated
    }

    private func makeResponse(unread: Int?) -> DashboardResponse {
        DashboardResponse(
            userName: "Test User",
            avatarUrl: nil,
            role: "STUDENT",
            schoolName: "Test School",
            unreadNotifications: unread,
            announcementsCount: nil
        )
    }
}

@Suite("HomeTileBadgeCounts")
struct HomeTileBadgeCountsTests {

    @Test("Zero is the empty value")
    func zeroIsEmpty() {
        let zero = HomeTileBadgeCounts.zero
        #expect(zero.pendingAttendance == 0)
        #expect(zero.upcomingExams == 0)
        #expect(zero.todayClasses == 0)
        #expect(zero.unreadMessages == 0)
        #expect(zero.unreadNotifications == 0)
        #expect(zero.pendingAssignments == 0)
    }

    @Test("Equatable diffs detect changes")
    func equatable() {
        var a = HomeTileBadgeCounts.zero
        var b = HomeTileBadgeCounts.zero
        #expect(a == b)
        b.unreadNotifications = 5
        #expect(a != b)
        a.unreadNotifications = 5
        #expect(a == b)
    }
}
