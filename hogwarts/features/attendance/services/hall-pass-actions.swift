import Foundation

/// Server actions for hall passes.
final class HallPassActions: Sendable {
    private let api = APIClient.shared

    func list(studentId: String? = nil, status: HallPassStatus? = nil) async throws -> HallPassListResponse {
        var query: [String: String] = [:]
        if let studentId, !studentId.isEmpty { query["student_id"] = studentId }
        if let status, status != .unknown {
            query["status"] = status.rawValue.uppercased()
        }
        return try await api.get(
            "/mobile/attendance/hall-pass",
            query: query,
            as: HallPassListResponse.self
        )
    }
}
