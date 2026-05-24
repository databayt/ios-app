import Foundation

/// Server actions for Notifications feature
/// Mirrors: src/components/platform/notifications/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class NotificationsActions: Sendable {

    private let api: APIClientProtocol

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    // MARK: - Read Actions

    /// Get notifications list (paginated)
    /// Web API: GET /mobile/notifications?page=N&per_page=N&unread=true
    /// Returns: {data: [...], total, unread_count, page, per_page}
    func getNotifications(
        schoolId: String,
        page: Int = 1,
        perPage: Int = 20,
        unreadOnly: Bool = false
    ) async throws -> NotificationsResponse {
        var params: [String: String] = [
            "page": String(page),
            "per_page": String(perPage)
        ]
        if unreadOnly { params["unread"] = "true" }

        return try await api.get(
            "/mobile/notifications",
            query: params,
            as: NotificationsResponse.self
        )
    }

    // MARK: - Write Actions

    /// Mark a single notification as read
    /// Web API: POST /mobile/notifications/{notificationId}/read
    func markAsRead(
        notificationId: String,
        schoolId: String
    ) async throws {
        struct EmptyBody: Encodable {}
        let _: EmptyResponse = try await api.post(
            "/mobile/notifications/\(notificationId)/read",
            body: EmptyBody()
        )
    }

    /// Mark all notifications as read
    /// Web API: POST /mobile/notifications/read-all
    func markAllAsRead(schoolId: String) async throws {
        struct EmptyBody: Encodable {}
        let _: EmptyResponse = try await api.post(
            "/mobile/notifications/read-all",
            body: EmptyBody()
        )
    }

    // NOTE: DELETE /mobile/notifications/{id} does not exist in the web API.
    // Notifications are read-only from the mobile side (mark read only).
}
