import Foundation

/// Per-conversation mutation API: archive / leave / mute / pin / mark-read.
/// Each endpoint is fire-and-forget — the backend responds with `{success: true}`
/// and we don't need to roundtrip the new state because the caller already
/// has it (optimistic update lives in the view model).
final class ConversationActionsService: Sendable {
    private let api = APIClient.shared

    private struct ArchiveBody: Encodable { let archived: Bool }
    private struct MuteBody: Encodable { let muted: Bool }
    private struct PinBody: Encodable { let pinned: Bool }
    private struct EmptyBody: Encodable {}

    @discardableResult
    func archive(conversationId: String, archived: Bool) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/conversations/\(conversationId)/archive",
            body: ArchiveBody(archived: archived),
            as: EmptyResponse.self
        )
    }

    @discardableResult
    func mute(conversationId: String, muted: Bool) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/conversations/\(conversationId)/mute",
            body: MuteBody(muted: muted),
            as: EmptyResponse.self
        )
    }

    @discardableResult
    func pin(conversationId: String, pinned: Bool) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/conversations/\(conversationId)/pin",
            body: PinBody(pinned: pinned),
            as: EmptyResponse.self
        )
    }

    @discardableResult
    func leave(conversationId: String) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/conversations/\(conversationId)/leave",
            body: EmptyBody(),
            as: EmptyResponse.self
        )
    }

    /// Reset the unread counter — typically called on chat-screen appear.
    @discardableResult
    func markRead(conversationId: String) async throws -> EmptyResponse {
        try await api.post(
            "/mobile/conversations/\(conversationId)/read",
            body: EmptyBody(),
            as: EmptyResponse.self
        )
    }
}
