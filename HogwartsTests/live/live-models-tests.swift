import Foundation
import Testing
@testable import Hogwarts

/// Decodes INVENTED payloads shaped like production's `/api/mobile/live/*` and
/// `/api/mobile/conference/*`, the way `APIClient` would (default decoder).
@Suite("Live DTOs")
struct LiveModelsTests {
    private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: Data(json.utf8))
    }

    @Test("landing decodes snake_case and keeps rows")
    func landing() throws {
        let json = """
        {
          "viewer": {"role":"TEACHER","can_schedule":true,"can_configure":false,"is_host":true,
                     "can_join":true,"can_view_recordings":true,"shows_teacher":false,"shows_section":true},
          "policy": {"delivery_mode":"online","is_online":true,"window_active":true,"provider":"livekit","degraded":false},
          "live": [{"id":"s1","title":"Algebra","teacher_name":"Sample Teacher","subject_name":"Maths",
                    "section_name":"7B","scheduled_start":"10:00","is_live":true,"phase":"STARTED",
                    "progress":{"done":12,"total":45},"has_recording":false}],
          "upcoming": [{"id":"s2","title":"Science","scheduled_start":"11:00","phase":"soon"}],
          "catch_up": [{"id":"s3","title":"History","scheduled_start":"8 Sep","phase":"past","has_recording":true}],
          "recordings": [],
          "readiness": {"livekit_ready":true,"recording_ready":false,"has_fallback":true}
        }
        """
        let landing = try decode(LiveLandingResponse.self, json)
        #expect(landing.viewer.isHost && landing.viewer.canJoin)
        #expect(!landing.viewer.showsTeacher && landing.viewer.showsSection)
        #expect(landing.policy.isOnline && landing.policy.provider == "livekit")
        #expect(landing.live.count == 1 && landing.live[0].isLive)
        #expect(landing.live[0].phase == .started)
        #expect(landing.live[0].progress == LandingProgress(done: 12, total: 45))
        #expect(landing.live[0].subjectLine(showsSection: true) == "Maths · 7B")
        #expect(landing.live[0].subjectLine(showsSection: false) == "Maths")
        #expect(landing.upcoming[0].phase == .soon && landing.upcoming[0].teacherName == "")
        #expect(landing.catchUp[0].hasRecording)
        #expect(landing.readiness?.livekitReady == true)
    }

    @Test("landing tolerates a sparse or hostile payload")
    func landingLenient() throws {
        let landing = try decode(LiveLandingResponse.self, #"{"live":[{"id":"x","phase":"weird","is_live":"yes"},{"nope":1}]}"#)
        // The malformed second row is dropped; the first still renders, with defaults for its bad fields.
        #expect(landing.live.map(\.id) == ["x"])
        #expect(landing.live[0].phase == .scheduled && !landing.live[0].isLive)
        #expect(landing.viewer.showsTeacher)
        #expect(!landing.policy.isOnline)
        let ok = try decode(LiveLandingResponse.self, #"{"live":[{"id":"x","phase":"weird"}]}"#)
        #expect(ok.live[0].phase == .scheduled)
    }

    @Test("session page decodes display-ready fields")
    func sessionPage() throws {
        let json = """
        {"id":"s1","title":"Algebra","when":"Today, 10:00","status":"live","status_label":"Live",
         "scheduled_start":"2026-11-15T08:00:00.000Z","description":"Chapter 3","can_join":true,
         "is_external":false,"can_end":true,
         "rows":[{"label":"Teacher","value":"Sample Teacher"},{"label":"Section","value":"7B"}],
         "labels":{"enter":"Enter","join":"Join"}}
        """
        let page = try decode(SessionPage.self, json)
        #expect(page.title == "Algebra" && page.when == "Today, 10:00")
        #expect(page.statusLabel == "Live" && page.canJoin && page.canEnd && !page.isExternal)
        #expect(page.rows.count == 2 && page.rows[1].value == "7B")
        #expect(page.labels["enter"] == "Enter")
        #expect(page.meetingURL == nil)
    }

    @Test("join ticket decodes camelCase with roomConfig tools")
    func joinTicket() throws {
        let json = """
        {"success":true,"data":{"token":"jwt.invented.token","wsUrl":"wss://live.example.test","roomName":"room-1",
         "identity":"user-7","role":"CO_HOST","hostIdentity":"user-1",
         "roomConfig":{"tools":{"chat":false,"hands":true,"studentShare":true},"joinMuted":true},
         "expiresAt":"2026-11-15T12:00:00.000Z"}}
        """
        let response = try decode(JoinResponse.self, json)
        let ticket = try #require(response.data)
        #expect(response.success && ticket.isHost)
        #expect(ticket.wsUrl == "wss://live.example.test" && ticket.hostIdentity == "user-1")
        #expect(ticket.roomConfig == RoomTools(chat: false, hands: true, studentShare: true, joinMuted: true))
    }

    @Test("join ticket without roomConfig and a refusal")
    func joinDefaultsAndRefusal() throws {
        let bare = try decode(JoinResponse.self, #"{"success":true,"data":{"token":"t","wsUrl":"wss://x.test","roomName":"r","identity":"i","role":"PARTICIPANT","expiresAt":"e"}}"#)
        #expect(bare.data?.isHost == false)
        #expect(bare.data?.roomConfig == nil)
        #expect(RoomTools() == RoomTools(chat: true, hands: true, studentShare: false, joinMuted: false))

        let refused = try decode(JoinResponse.self, #"{"success":false,"error":"LIVE_CLASS_ROOM_FULL"}"#)
        #expect(!refused.success && refused.data == nil && refused.error == "LIVE_CLASS_ROOM_FULL")

        // Partial tools object: the missing switches keep their defaults.
        let partial = try decode(RoomTools.self, #"{"tools":{"studentShare":true}}"#)
        #expect(partial == RoomTools(chat: true, hands: true, studentShare: true, joinMuted: false))
    }

    @Test("chat page decodes and drops one bad message, not the page")
    func chatPage() throws {
        let json = """
        {"success":true,"data":{"messages":[
           {"id":"m1","identity":"user-7","name":"Sample Student","text":"hello","at":1700000000000},
           {"id":"bad"},
           {"id":"m2","identity":"user-1","text":"welcome","at":1700000005000}],
         "hasMore":true}}
        """
        let page = try decode(RoomChatResponse.self, json)
        #expect(page.success && page.hasMore)
        #expect(page.messages.map(\.id) == ["m1", "m2"])
        #expect(page.messages[1].name == "")
        #expect(page.messages[0].at == 1_700_000_000_000)

        let empty = try decode(RoomChatResponse.self, #"{"success":false,"error":"x"}"#)
        #expect(empty.messages.isEmpty && !empty.success)
    }

    @Test("requests encode the wire shape")
    func requests() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let chat = try encoder.encode(RecordChatRequest(messageId: "m1", text: "hi"))
        #expect(String(data: chat, encoding: .utf8) == #"{"messageId":"m1","text":"hi"}"#)
        let mute = try encoder.encode(MuteRequest(identity: nil))
        #expect(String(data: mute, encoding: .utf8) == "{}")
        let one = try encoder.encode(MuteRequest(identity: "user-7"))
        #expect(String(data: one, encoding: .utf8) == #"{"identity":"user-7"}"#)
    }

    @Test("screen-share cancel is silent, other errors are not")
    func shareErrors() {
        #expect(LiveRoomViewModel.isUserCancel(CancellationError()))
        #expect(!LiveRoomViewModel.isUserCancel(NSError(domain: "x", code: 1)))
    }
}
