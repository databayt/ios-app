import Foundation

// MARK: - DTOs
//
// Mirrors `/api/mobile/starred-messages` (list of messages the user has
// starred across all conversations) and `/api/mobile/messages/search?q=`.
//
// The backend already ships these in camelCase, so APIClient's
// `.convertFromSnakeCase` is a no-op for these fields.

struct StarredMessage: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let starredAt: Date
    let message: StarredMessageBody
}

struct StarredMessageBody: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let conversationId: String
    let conversationTitle: String
    let conversationType: String?
    let senderId: String
    let senderName: String
    let content: String
    let contentType: String?
    let sentAt: Date
}

struct StarredMessagesResponse: Codable, Sendable {
    let data: [StarredMessage]
    let total: Int
}

// MARK: - Search

struct MessageSearchHit: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let conversationId: String
    let conversationTitle: String
    let conversationType: String?
    let senderId: String
    let senderName: String
    let content: String
    let sentAt: Date
}

struct MessageSearchResponse: Codable, Sendable {
    let data: [MessageSearchHit]
    let total: Int
}
