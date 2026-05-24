import Foundation

/// Server actions for Profile feature
/// Mirrors: src/components/platform/profile/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class ProfileActions: Sendable {

    private let api: APIClientProtocol

    /// Default-arg init keeps every existing `ProfileActions()` call site
    /// untouched; tests inject a `MockAPIClient` without reaching for
    /// `APIClient.shared`.
    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    // MARK: - Profile

    /// Get current user profile
    /// Web API: GET /mobile/profile — returns full profile with nested student/teacher/school
    func getProfile(schoolId: String) async throws -> User {
        return try await api.get("/mobile/profile", as: User.self)
    }

    /// Update profile fields
    /// Web API: PUT /mobile/profile — body: {username?, bio?}
    func updateProfile(
        _ request: ProfileUpdateRequest,
        schoolId: String
    ) async throws -> User {
        return try await api.put("/mobile/profile", body: request, as: User.self)
    }

    // NOTE: Notification preferences endpoints (/mobile/notifications/preferences)
    // are being added separately to the web API and are not yet available.
}
