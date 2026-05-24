import Foundation

/// Server actions for Messages feature
/// Mirrors: src/components/platform/messages/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class MessagesActions: Sendable {

    private let api: APIClientProtocol
    private let syncEngine = SyncEngine.shared

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    // MARK: - Read Actions

    /// Get conversations list
    /// Web API: GET /mobile/conversations?type=X
    /// Returns: {data: [{id, type, title, avatarUrl, unreadCount, ...}], total}
    /// NOTE: This endpoint returns camelCase field names directly
    func getConversations(
        schoolId: String,
        type: String? = nil
    ) async throws -> ConversationsResponse {
        var params: [String: String] = [:]
        if let type { params["type"] = type }

        return try await api.get(
            "/mobile/conversations",
            query: params,
            as: ConversationsResponse.self
        )
    }

    /// Get messages in a conversation (cursor-based pagination)
    /// Web API: GET /mobile/conversations/{id}/messages?cursor=X&limit=N
    /// Returns: {data: [...], next_cursor}
    func getMessages(
        conversationId: String,
        schoolId: String,
        cursor: String? = nil,
        limit: Int = 20
    ) async throws -> MessagesResponse {
        var params: [String: String] = [
            "limit": String(limit)
        ]
        if let cursor { params["cursor"] = cursor }

        return try await api.get(
            "/mobile/conversations/\(conversationId)/messages",
            query: params,
            as: MessagesResponse.self
        )
    }

    // MARK: - Write Actions

    /// Send a message in a conversation
    /// Web API: POST /mobile/conversations/{conversationId}/messages
    /// Body: {content, reply_to_id?, nonce?}
    func sendMessage(
        conversationId: String,
        content: String,
        replyToId: String? = nil,
        nonce: String? = nil,
        schoolId: String
    ) async throws -> Message {
        struct SendRequest: Encodable {
            let content: String
            let replyToId: String?
            let nonce: String?
        }

        let body = SendRequest(content: content, replyToId: replyToId, nonce: nonce)
        return try await api.post(
            "/mobile/conversations/\(conversationId)/messages",
            body: body,
            as: Message.self
        )
    }

    /// Create a new conversation
    /// Web API: POST /mobile/conversations
    /// Body: {type?, title?, participant_ids: [...]}
    /// Returns: {id}
    func createConversation(
        participantIds: [String],
        type: String? = nil,
        title: String? = nil,
        schoolId: String
    ) async throws -> CreateConversationResponse {
        struct CreateRequest: Encodable {
            let type: String?
            let title: String?
            let participantIds: [String]
        }

        let body = CreateRequest(type: type, title: title, participantIds: participantIds)
        return try await api.post("/mobile/conversations", body: body, as: CreateConversationResponse.self)
    }

    /// Mark conversation as read
    /// Web API: POST /mobile/conversations/{conversationId}/read
    func markAsRead(
        conversationId: String,
        schoolId: String
    ) async throws {
        struct EmptyBody: Encodable {}
        let _: EmptyResponse = try await api.post(
            "/mobile/conversations/\(conversationId)/read",
            body: EmptyBody()
        )
    }

    // NOTE: /mobile/users and /mobile/contacts do not exist as mobile API
    // endpoints. Recipients for conversations are handled via conversation creation.

    // MARK: - Offline Actions

    /// Send message (offline-capable)
    @MainActor
    func sendMessageOffline(
        conversationId: String,
        content: String,
        schoolId: String
    ) async throws -> Message? {
        if NetworkMonitor.shared.isConnected {
            return try await sendMessage(
                conversationId: conversationId,
                content: content,
                schoolId: schoolId
            )
        }

        // Queue for later
        struct OfflineMessageRequest: Encodable {
            let content: String
        }
        let request = OfflineMessageRequest(content: content)
        let payload = try JSONEncoder().encode(request)
        await syncEngine.queueAction(
            endpoint: "/mobile/conversations/\(conversationId)/messages",
            method: .post,
            payload: payload
        )

        return nil
    }
}

// MARK: - Errors

enum MessagesError: LocalizedError {
    case validationFailed([String: String])
    case conversationNotFound
    case unauthorized
    case sendFailed
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return errors.values.joined(separator: ", ")
        case .conversationNotFound:
            return String(localized: "messages.error.notFound")
        case .unauthorized:
            return String(localized: "error.unauthorized")
        case .sendFailed:
            return String(localized: "messages.error.sendFailed")
        case .serverError(let message):
            return message
        }
    }
}
