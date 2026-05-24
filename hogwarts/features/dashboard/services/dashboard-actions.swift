import Foundation

/// Dashboard API actions
/// Web API: Single GET /mobile/dashboard returns all dashboard data
/// Response includes role-specific fields automatically
struct DashboardActions {
    private let api = APIClient.shared

    /// Fetch dashboard data — single endpoint returns everything
    /// Response shape: {user_name, avatar_url, role, school_name,
    ///   unread_notifications, announcements_count, ...role-specific fields}
    func fetchDashboard() async throws -> DashboardResponse {
        try await api.get("/mobile/dashboard", as: DashboardResponse.self)
    }
}

/// Unified dashboard response from GET /mobile/dashboard
/// Contains common fields plus role-specific extras
struct DashboardResponse: Codable {
    // Common fields
    let userName: String?
    let avatarUrl: String?
    let role: String?
    let schoolName: String?
    let unreadNotifications: Int?
    let announcementsCount: Int?

    // Role-specific fields are dynamic — decoded as needed
    // Student: schedule, grades, attendance summary
    // Teacher: today's classes, pending tasks
    // Guardian: children list
    // Admin: stats overview
}
