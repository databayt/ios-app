import Foundation

/// Server actions for the Notification Preferences screen.
final class NotificationPreferencesActions: Sendable {
    private let api = APIClient.shared

    /// Fetch the user's notification preferences. When the user has never
    /// adjusted them the backend returns an empty `data` array along with
    /// a `defaults` object — callers should compose effective values from
    /// both (`stored ?? defaults[channel] ?? true`).
    func fetch() async throws -> NotificationPreferencesResponse {
        try await api.get(
            "/mobile/notifications/preferences",
            as: NotificationPreferencesResponse.self
        )
    }

    /// Update one or more (type, channel) toggles. Backend upserts on
    /// `(userId, type, channel)`.
    @discardableResult
    func update(preferences: [NotificationPreferenceUpdate]) async throws -> EmptyResponse {
        try await api.put(
            "/mobile/notifications/preferences",
            body: NotificationPreferencesUpdateBody(preferences: preferences),
            as: EmptyResponse.self
        )
    }
}
