import Foundation

/// Server actions for the Teacher feature.
final class TeacherActions: Sendable {
    private let api = APIClient.shared

    /// Distinct (section, subject) pairs the teacher is timetabled for.
    func classes() async throws -> TeacherClassesResponse {
        try await api.get("/mobile/teacher/classes", as: TeacherClassesResponse.self)
    }

    /// Weekly schedule. `day` filters to a single day (0 = Sunday).
    func schedule(day: Int? = nil) async throws -> TeacherScheduleResponse {
        var query: [String: String] = [:]
        if let day { query["day"] = String(day) }
        return try await api.get(
            "/mobile/teacher/schedule",
            query: query,
            as: TeacherScheduleResponse.self
        )
    }
}
