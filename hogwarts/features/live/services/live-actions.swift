import Foundation

/// Live-class endpoints. Every call goes through `APIClient` (Bearer token, school scoping server-side).
/// Mirrors Android `live-api.kt` / `live-repository-impl.kt`.
final class LiveActions: Sendable {
    private let api: APIClient

    init(api: APIClient = APIClient.shared) {
        self.api = api
    }

    /// The wire language: the phone's, `en` or else `ar` (the web's two).
    static var wireLanguage: String {
        Locale.current.language.languageCode?.identifier == "en" ? "en" : "ar"
    }

    func landing() async throws -> LiveLandingResponse {
        try await api.get("/mobile/live/landing", query: ["lang": Self.wireLanguage], as: LiveLandingResponse.self)
    }

    func session(id: String) async throws -> SessionPage {
        try await api.get("/mobile/live/sessions/\(id)", query: ["lang": Self.wireLanguage], as: SessionPage.self)
    }

    /// The room ticket (`performLiveClassJoin`). A refusal comes back in-band as `error`, or as an HTTP
    /// status that is mapped to the same codes (Android reads `HTTP_<code>`).
    func join(id: String) async throws -> JoinResponse {
        do {
            return try await api.get("/mobile/conference/\(id)/join", as: JoinResponse.self)
        } catch APIError.forbidden {
            return JoinResponse(error: "LIVE_CLASS_PARTICIPANT_DENIED")
        } catch APIError.notFound {
            return JoinResponse(error: "LIVE_CLASS_NOT_FOUND")
        } catch APIError.validationFailed {
            return JoinResponse(error: "LIVE_CLASS_INVALID_STATE")
        }
    }

    /// Saved room-chat history, newest page, oldest first. Failure → empty (history is a nicety).
    func chatHistory(id: String, before: Int64? = nil) async -> [RoomChatMessage] {
        var query: [String: String] = [:]
        if let before { query["before"] = String(before) }
        let page = try? await api.get("/mobile/conference/\(id)/chat", query: query, as: RoomChatResponse.self)
        return page?.messages ?? []
    }

    /// Save a message already sent over the room. Fire-and-forget: failure is non-fatal.
    func recordChat(id: String, messageId: String, text: String) async {
        _ = try? await api.post(
            "/mobile/conference/\(id)/chat",
            body: RecordChatRequest(messageId: messageId, text: text),
            as: SimpleResult.self
        )
    }

    /// Host: mute every student's microphone server-side.
    func muteAll(id: String) async -> Bool {
        let result = try? await api.post(
            "/mobile/conference/\(id)/mute",
            body: MuteRequest(identity: nil),
            as: SimpleResult.self
        )
        return result?.success == true
    }
}
