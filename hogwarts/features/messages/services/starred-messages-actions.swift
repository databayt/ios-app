import Foundation

/// Server actions for starred messages + global message search.
final class StarredMessagesActions: Sendable {
    private let api = APIClient.shared

    /// Most-recent-first list of the user's starred messages.
    func list(limit: Int = 50) async throws -> StarredMessagesResponse {
        try await api.get(
            "/mobile/starred-messages",
            query: ["limit": String(limit)],
            as: StarredMessagesResponse.self
        )
    }

    /// Cross-conversation message search by substring.
    func search(query: String, limit: Int = 50) async throws -> MessageSearchResponse {
        try await api.get(
            "/mobile/messages/search",
            query: ["q": query, "limit": String(limit)],
            as: MessageSearchResponse.self
        )
    }
}
