import Foundation

/// Server actions for the Report Cards feature.
final class ReportCardsActions: Sendable {
    private let api = APIClient.shared

    /// List all report cards for the current student. When called by a
    /// guardian or teacher, an explicit `studentId` filter is required.
    func list(studentId: String? = nil, page: Int = 1, perPage: Int = 20)
        async throws -> ReportCardsListResponse
    {
        var query: [String: String] = [
            "page": String(page),
            "per_page": String(perPage),
        ]
        if let id = studentId, !id.isEmpty { query["student_id"] = id }
        return try await api.get(
            "/mobile/report-cards",
            query: query,
            as: ReportCardsListResponse.self
        )
    }

    /// Single report card with per-subject breakdown.
    func detail(id: String) async throws -> ReportCardDetail {
        try await api.get("/mobile/report-cards/\(id)", as: ReportCardDetail.self)
    }
}
