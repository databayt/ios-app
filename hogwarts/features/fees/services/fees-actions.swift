import Foundation

/// Server actions for the Fees feature.
final class FeesActions: Sendable {
    private let api = APIClient.shared

    /// Fee records — backend resolves the active student from the JWT when
    /// `studentId` is omitted, or honors the explicit value for guardians.
    func list(
        studentId: String? = nil,
        status: FeeStatus? = nil,
        page: Int = 1,
        perPage: Int = 30
    ) async throws -> FeeListResponse {
        var query: [String: String] = [
            "page": String(page),
            "per_page": String(perPage),
        ]
        if let studentId, !studentId.isEmpty { query["student_id"] = studentId }
        if let status, status != .unknown {
            query["status"] = status.rawValue.uppercased()
        }
        return try await api.get(
            "/mobile/fees",
            query: query,
            as: FeeListResponse.self
        )
    }

    /// Aggregate summary — feeds the top card on the fees screen.
    /// `studentId` is required by the backend route.
    func summary(studentId: String) async throws -> FeeSummary {
        try await api.get(
            "/mobile/fees/summary/\(studentId)",
            as: FeeSummary.self
        )
    }
}
