import Foundation

/// Server actions for Timetable feature
/// Mirrors: src/components/platform/timetable/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class TimetableActions: Sendable {

    private let api = APIClient.shared

    // MARK: - Read Actions

    /// Get timetable for a user on a specific day
    /// Web API: GET /mobile/timetable/{userId}?day=N (0=Sunday..6=Saturday)
    func getTimetable(
        userId: String,
        day: Int? = nil
    ) async throws -> [TimetableEntry] {
        var params: [String: String] = [:]
        if let day {
            params["day"] = String(day)
        }

        return try await api.get(
            "/mobile/timetable/\(userId)",
            query: params,
            as: [TimetableEntry].self
        )
    }

    /// Get today's schedule for a user (convenience)
    /// Uses the day query param with today's weekday
    func getTodaySchedule(
        userId: String,
        schoolId: String
    ) async throws -> [TimetableEntry] {
        let weekday = Calendar.current.component(.weekday, from: Date())
        // Calendar weekday: 1=Sunday..7=Saturday → API day: 0=Sunday..6=Saturday
        let day = weekday - 1

        return try await getTimetable(userId: userId, day: day)
    }

    // NOTE: GET /mobile/timetable/today and GET /mobile/classes/{id} do not exist
    // in the web API. Use GET /mobile/timetable/{userId}?day=N instead.
    // For class/section details, use GET /mobile/teacher/classes.
}
