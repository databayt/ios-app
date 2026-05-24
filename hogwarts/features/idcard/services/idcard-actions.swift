import Foundation

/// Server actions for the ID Card feature.
final class IDCardActions: Sendable {
    private let api = APIClient.shared

    /// Fetch the digital ID card for the current user. Backend reads identity
    /// from the JWT — no params needed.
    func fetch() async throws -> IDCardResponse {
        try await api.get("/mobile/idcard", as: IDCardResponse.self)
    }
}
