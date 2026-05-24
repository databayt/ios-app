import Foundation
import SwiftUI

@MainActor
@Observable
final class AttendanceGamificationViewModel {
    private(set) var badges: [AttendanceBadge] = []
    private(set) var streak: AttendanceStreak?
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: AttendanceGamificationActions

    init(actions: AttendanceGamificationActions = .init()) {
        self.actions = actions
    }

    var earnedBadges: [AttendanceBadge] { badges.filter(\.isEarned) }
    var unearnedBadges: [AttendanceBadge] { badges.filter { !$0.isEarned } }

    /// Total point value of earned badges — surfaced as a hero stat.
    var earnedPoints: Int {
        earnedBadges.compactMap(\.pointValue).reduce(0, +)
    }

    func load(studentId: String?) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        async let badgesTask = actions.badges(studentId: studentId)
        async let streakTask: AttendanceStreak? = {
            // Streak is per-student; tolerate missing student id by skipping.
            do { return try await actions.streak(studentId: studentId) }
            catch { return nil }
        }()

        do {
            badges = try await badgesTask.data
            streak = await streakTask
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
