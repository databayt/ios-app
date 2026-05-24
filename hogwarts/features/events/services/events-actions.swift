import Foundation

/// Server actions for the Events feature.
/// Mirrors web `/api/mobile/events` (list) and `/api/mobile/events/:id` (detail).
final class EventsActions: Sendable {
    private let api = APIClient.shared

    /// Paginated events list. `upcoming = true` filters to today and forward.
    func list(upcoming: Bool = false, page: Int = 1, perPage: Int = 20)
        async throws -> SchoolEventsListResponse
    {
        var query: [String: String] = [
            "page": String(page),
            "per_page": String(perPage),
        ]
        if upcoming { query["upcoming"] = "true" }
        return try await api.get(
            "/mobile/events",
            query: query,
            as: SchoolEventsListResponse.self
        )
    }

    /// Event detail — includes registration status for the current user.
    func detail(id: String) async throws -> SchoolEventDetail {
        try await api.get("/mobile/events/\(id)", as: SchoolEventDetail.self)
    }
}
