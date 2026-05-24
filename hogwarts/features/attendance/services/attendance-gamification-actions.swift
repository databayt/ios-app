import Foundation

/// Server actions for attendance gamification (badges + streaks).
final class AttendanceGamificationActions: Sendable {
    private let api = APIClient.shared

    /// All badges for the school, with `is_earned` populated for the
    /// current student when no `studentId` is passed (backend resolves
    /// the linked student from the JWT).
    func badges(studentId: String? = nil) async throws -> AttendanceBadgesResponse {
        var query: [String: String] = [:]
        if let studentId, !studentId.isEmpty { query["student_id"] = studentId }
        return try await api.get(
            "/mobile/attendance/badges",
            query: query,
            as: AttendanceBadgesResponse.self
        )
    }

    /// Streak counts. Backend requires `studentId` — the iOS layer either
    /// passes the active student id (guardian flow) or omits it and lets
    /// the backend resolve from the JWT (student flow).
    func streak(studentId: String? = nil) async throws -> AttendanceStreak {
        var query: [String: String] = [:]
        if let studentId, !studentId.isEmpty { query["student_id"] = studentId }
        return try await api.get(
            "/mobile/attendance/streaks",
            query: query,
            as: AttendanceStreak.self
        )
    }
}
