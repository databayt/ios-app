import Foundation
import Testing
@testable import Hogwarts

@Suite("AttendanceGamificationViewModel")
@MainActor
struct AttendanceGamificationViewModelTests {

    @Test("earnedBadges and unearnedBadges partition correctly")
    func partition() {
        let vm = AttendanceGamificationViewModel()
        vm._setBadgesForTests([
            badge("a", earned: true),
            badge("b", earned: false),
            badge("c", earned: true),
        ])
        #expect(vm.earnedBadges.count == 2)
        #expect(vm.unearnedBadges.count == 1)
        #expect(vm.unearnedBadges.first?.id == "b")
    }

    @Test("earnedPoints sums only earned badges")
    func earnedPoints() {
        let vm = AttendanceGamificationViewModel()
        vm._setBadgesForTests([
            badge("a", earned: true,  points: 10),
            badge("b", earned: false, points: 100),  // ignored
            badge("c", earned: true,  points: 5),
        ])
        #expect(vm.earnedPoints == 15)
    }

    @Test("nil point values count as zero")
    func nilPoints() {
        let vm = AttendanceGamificationViewModel()
        vm._setBadgesForTests([
            badge("a", earned: true, points: nil),
            badge("b", earned: true, points: 7),
        ])
        #expect(vm.earnedPoints == 7)
    }

    private func badge(_ id: String, earned: Bool, points: Int? = nil) -> AttendanceBadge {
        AttendanceBadge(
            id: id, code: nil, name: "Badge \(id)", description: nil,
            icon: nil, color: nil, pointValue: points,
            isEarned: earned, earnedAt: earned ? Date() : nil
        )
    }
}

extension AttendanceGamificationViewModel {
    func _setBadgesForTests(_ badges: [AttendanceBadge]) {
        self.badges = badges
    }
}

@Suite("AttendanceStreak.monthlyAttendanceRate")
struct AttendanceStreakRateTests {

    @Test("Computes rate when totals exist")
    func ratio() {
        let s = AttendanceStreak(
            currentStreak: 0, longestStreak: 0,
            streakStartDate: nil, lastPresentDate: nil,
            monthlyPresent: 18, monthlyLate: 1, monthlyAbsent: 1
        )
        // 18 / 20 = 0.90
        #expect(abs((s.monthlyAttendanceRate ?? 0) - 0.9) < 0.001)
    }

    @Test("Nil when no school days recorded")
    func nilWhenZero() {
        let s = AttendanceStreak(
            currentStreak: 0, longestStreak: 0,
            streakStartDate: nil, lastPresentDate: nil,
            monthlyPresent: 0, monthlyLate: 0, monthlyAbsent: 0
        )
        #expect(s.monthlyAttendanceRate == nil)
    }
}

@Suite("HallPass.minutesRemaining")
struct HallPassRemainingTests {

    @Test("Positive when before expected return")
    func positive() {
        let now = Date()
        let pass = HallPass(
            id: "1", studentId: "s", studentName: nil, classId: nil,
            destination: nil, destinationNote: nil, issuedBy: nil,
            issuedAt: now,
            expectedDuration: 10,
            expectedReturn: now.addingTimeInterval(60 * 5),  // +5 min
            returnedAt: nil, status: "ACTIVE"
        )
        #expect(pass.minutesRemaining(now: now) == 5)
    }

    @Test("Negative when overdue")
    func negative() {
        let now = Date()
        let pass = HallPass(
            id: "1", studentId: "s", studentName: nil, classId: nil,
            destination: nil, destinationNote: nil, issuedBy: nil,
            issuedAt: now.addingTimeInterval(-60 * 20),
            expectedDuration: 10,
            expectedReturn: now.addingTimeInterval(-60 * 3),  // 3 min ago
            returnedAt: nil, status: "OVERDUE"
        )
        #expect(pass.minutesRemaining(now: now) == -3)
    }
}

@Suite("HallPassStatus")
struct HallPassStatusTests {

    @Test("Maps backend strings", arguments: [
        ("ACTIVE", HallPassStatus.active),
        ("RETURNED", .returned),
        ("OVERDUE", .overdue),
        ("CANCELLED", .cancelled),
    ])
    func mapsCanonical(raw: String, expected: HallPassStatus) {
        #expect(HallPassStatus(raw: raw) == expected)
    }

    @Test("Unknown for junk")
    func unknown() {
        #expect(HallPassStatus(raw: "WAITING") == .unknown)
    }
}
