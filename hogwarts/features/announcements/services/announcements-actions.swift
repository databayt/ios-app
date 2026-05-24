import Foundation

/// Server actions for the Announcements feature.
/// Mirrors web `/api/mobile/announcements` (list) and `/api/mobile/announcements/:id` (detail).
///
/// CRITICAL: every call goes through `APIClient`, which already injects
/// `Authorization` and `Accept-Language`; the backend scopes responses by
/// `schoolId` derived from the JWT, so callers don't pass it explicitly.
final class AnnouncementsActions: Sendable {
    private let api = APIClient.shared

    /// Paginated announcements list. Web returns 20 per page by default.
    func list(page: Int = 1, perPage: Int = 20) async throws -> AnnouncementsListResponse {
        try await api.get(
            "/mobile/announcements",
            query: ["page": String(page), "per_page": String(perPage)],
            as: AnnouncementsListResponse.self
        )
    }

    /// Announcement detail. The backend also marks the item as read for the
    /// current user as a side effect — we don't surface that on the client.
    func detail(id: String) async throws -> AnnouncementDetail {
        try await api.get("/mobile/announcements/\(id)", as: AnnouncementDetail.self)
    }
}
