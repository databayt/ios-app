import Foundation

/// Server actions for the Admin feature.
final class AdminActions: Sendable {
    private let api = APIClient.shared

    func stats() async throws -> AdminStats {
        try await api.get("/mobile/admin/stats", as: AdminStats.self)
    }

    func school() async throws -> AdminSchool {
        try await api.get("/mobile/admin/school", as: AdminSchool.self)
    }

    func staff(filter: AdminStaffFilter = .all, page: Int = 1, perPage: Int = 30)
        async throws -> AdminStaffResponse
    {
        var query: [String: String] = [
            "page": String(page),
            "per_page": String(perPage),
        ]
        if let role = filter.apiParam { query["role"] = role }
        return try await api.get(
            "/mobile/admin/staff",
            query: query,
            as: AdminStaffResponse.self
        )
    }

    func classes(page: Int = 1, perPage: Int = 30) async throws -> AdminClassesResponse {
        try await api.get(
            "/mobile/admin/classes",
            query: ["page": String(page), "per_page": String(perPage)],
            as: AdminClassesResponse.self
        )
    }
}
