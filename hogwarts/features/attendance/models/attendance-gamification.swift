import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/attendance/badges` (list of all school badges with
// `is_earned` flag per current student) and `/api/mobile/attendance/streaks`
// (current/longest streak + monthly counters).

struct AttendanceBadge: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let code: String?
    let name: String
    let description: String?
    let icon: String?
    let color: String?
    let pointValue: Int?
    let isEarned: Bool
    let earnedAt: Date?
}

struct AttendanceBadgesResponse: Codable, Sendable {
    let data: [AttendanceBadge]
}

struct AttendanceStreak: Codable, Sendable {
    let currentStreak: Int
    let longestStreak: Int
    let streakStartDate: Date?
    let lastPresentDate: Date?
    let monthlyPresent: Int
    let monthlyLate: Int
    let monthlyAbsent: Int

    /// Convenience for the monthly bar — % of school days the student
    /// actually showed up. Returns nil when there are zero school days
    /// recorded so the UI can show an empty state instead of "0%".
    var monthlyAttendanceRate: Double? {
        let total = monthlyPresent + monthlyLate + monthlyAbsent
        guard total > 0 else { return nil }
        return Double(monthlyPresent) / Double(total)
    }
}
