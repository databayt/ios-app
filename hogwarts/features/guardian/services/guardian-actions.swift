import Foundation

/// Server actions for the Guardian feature.
///
/// Every endpoint resolves the active guardian from the JWT, then scopes
/// to the requested child by id — the iOS layer just passes the child id
/// through to the existing fees/grades/attendance/timetable feature views.
final class GuardianActions: Sendable {
    private let api = APIClient.shared

    /// All children linked to the signed-in guardian.
    func children() async throws -> ChildrenListResponse {
        try await api.get("/mobile/guardian/children", as: ChildrenListResponse.self)
    }

    /// Full child profile (admission, contact, section).
    func childDetail(childId: String) async throws -> ChildDetail {
        try await api.get(
            "/mobile/guardian/children/\(childId)",
            as: ChildDetail.self
        )
    }
}
