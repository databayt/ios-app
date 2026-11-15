import Foundation

// Wire models for the live-class block.
//
// Truth: the web's `loadLiveLanding` / `/live/[id]` loaders and `performLiveClassJoin`, served as
// JSON by `/api/mobile/live/*` and `/api/mobile/conference/*`. Ported from the Android DTOs
// (`feature/live/.../dto/*.kt`). `APIClient` decodes with default keys, so every key is explicit
// here and every field is lenient: a missing or malformed field becomes its default instead of
// failing the whole screen (same as Android's `= default` properties).

extension KeyedDecodingContainer {
    /// `decodeIfPresent` that never throws: missing, null or mistyped → `fallback`.
    func lenient<T: Decodable>(_ key: Key, _ fallback: T) -> T {
        (try? decodeIfPresent(T.self, forKey: key)) ?? fallback
    }

    /// An array that drops malformed elements instead of failing (or emptying) the whole list.
    func lenientArray<T: Decodable>(_ key: Key) -> [T] {
        let boxes: [LossyBox<T>] = lenient(key, [])
        return boxes.compactMap(\.value)
    }

    /// Optional that never throws.
    func lenient<T: Decodable>(_ key: Key) -> T? {
        (try? decodeIfPresent(T.self, forKey: key)) ?? nil
    }
}

// MARK: - Landing (`GET /mobile/live/landing?lang=`)

struct LiveLandingResponse: Decodable, Sendable, Equatable {
    var viewer: LandingViewer
    var policy: LandingPolicy
    var live: [LandingSession]
    var upcoming: [LandingSession]
    var catchUp: [LandingSession]
    var recordings: [LandingSession]
    var readiness: LandingReadiness?

    enum CodingKeys: String, CodingKey {
        case viewer, policy, live, upcoming, recordings, readiness
        case catchUp = "catch_up"
    }

    init(viewer: LandingViewer = .init(), policy: LandingPolicy = .init(), live: [LandingSession] = [],
         upcoming: [LandingSession] = [], catchUp: [LandingSession] = [],
         recordings: [LandingSession] = [], readiness: LandingReadiness? = nil) {
        self.viewer = viewer; self.policy = policy; self.live = live; self.upcoming = upcoming
        self.catchUp = catchUp; self.recordings = recordings; self.readiness = readiness
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        viewer = c.lenient(.viewer, LandingViewer())
        policy = c.lenient(.policy, LandingPolicy())
        live = c.lenientArray(.live)
        upcoming = c.lenientArray(.upcoming)
        catchUp = c.lenientArray(.catchUp)
        recordings = c.lenientArray(.recordings)
        readiness = c.lenient(.readiness)
    }
}

struct LandingViewer: Decodable, Sendable, Equatable {
    var role = ""
    var canSchedule = false
    var canConfigure = false
    var isHost = false
    var canJoin = false
    var canViewRecordings = false
    var showsTeacher = true
    var showsSection = true

    enum CodingKeys: String, CodingKey {
        case role
        case canSchedule = "can_schedule", canConfigure = "can_configure", isHost = "is_host"
        case canJoin = "can_join", canViewRecordings = "can_view_recordings"
        case showsTeacher = "shows_teacher", showsSection = "shows_section"
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        role = c.lenient(.role, "")
        canSchedule = c.lenient(.canSchedule, false)
        canConfigure = c.lenient(.canConfigure, false)
        isHost = c.lenient(.isHost, false)
        canJoin = c.lenient(.canJoin, false)
        canViewRecordings = c.lenient(.canViewRecordings, false)
        showsTeacher = c.lenient(.showsTeacher, true)
        showsSection = c.lenient(.showsSection, true)
    }
}

struct LandingPolicy: Decodable, Sendable, Equatable {
    var deliveryMode = "physical"
    var isOnline = false
    var windowActive = false
    var provider = "external"
    var degraded = false

    enum CodingKeys: String, CodingKey {
        case deliveryMode = "delivery_mode", isOnline = "is_online", windowActive = "window_active"
        case provider, degraded
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        deliveryMode = c.lenient(.deliveryMode, "physical")
        isOnline = c.lenient(.isOnline, false)
        windowActive = c.lenient(.windowActive, false)
        provider = c.lenient(.provider, "external")
        degraded = c.lenient(.degraded, false)
    }
}

struct LandingReadiness: Decodable, Sendable, Equatable {
    var livekitReady = false
    var recordingReady = false
    var hasFallback = false

    enum CodingKeys: String, CodingKey {
        case livekitReady = "livekit_ready", recordingReady = "recording_ready", hasFallback = "has_fallback"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        livekitReady = c.lenient(.livekitReady, false)
        recordingReady = c.lenient(.recordingReady, false)
        hasFallback = c.lenient(.hasFallback, false)
    }
}

/// Where a class sits in its own clock, resolved server-side.
enum LandingPhase: String, Sendable {
    case soon, started, ending, scheduled, past

    init(wire: String) { self = LandingPhase(rawValue: wire.lowercased()) ?? .scheduled }
}

struct LandingProgress: Decodable, Sendable, Equatable {
    var done: Int
    var total: Int
}

/// One class, already localized, its time formatted in the school's zone.
struct LandingSession: Decodable, Sendable, Equatable, Identifiable {
    var id: String
    var title = ""
    var teacherName = ""
    var subjectName: String?
    var sectionName: String?
    var gradeName: String?
    var scheduledStart = ""
    var isLive = false
    var phase = LandingPhase.scheduled
    var progress: LandingProgress?
    var hasRecording = false

    enum CodingKeys: String, CodingKey {
        case id, title, phase, progress
        case teacherName = "teacher_name", subjectName = "subject_name", sectionName = "section_name"
        case gradeName = "grade_name", scheduledStart = "scheduled_start", isLive = "is_live"
        case hasRecording = "has_recording"
    }

    init(id: String, title: String = "", teacherName: String = "", subjectName: String? = nil,
         sectionName: String? = nil, scheduledStart: String = "", isLive: Bool = false,
         phase: LandingPhase = .scheduled) {
        self.id = id; self.title = title; self.teacherName = teacherName
        self.subjectName = subjectName; self.sectionName = sectionName
        self.scheduledStart = scheduledStart; self.isLive = isLive; self.phase = phase
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = c.lenient(.title, "")
        teacherName = c.lenient(.teacherName, "")
        subjectName = c.lenient(.subjectName)
        sectionName = c.lenient(.sectionName)
        gradeName = c.lenient(.gradeName)
        scheduledStart = c.lenient(.scheduledStart, "")
        isLive = c.lenient(.isLive, false)
        phase = LandingPhase(wire: c.lenient(.phase, "scheduled"))
        progress = c.lenient(.progress)
        hasRecording = c.lenient(.hasRecording, false)
    }

    /// "Mathematics · 7B", whichever parts exist.
    func subjectLine(showsSection: Bool) -> String {
        [subjectName, showsSection ? sectionName : nil]
            .compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · ")
    }
}

// MARK: - Session page (`GET /mobile/live/sessions/{id}?lang=`)

struct SessionPage: Decodable, Sendable, Equatable {
    var id: String
    var title = ""
    var when = ""
    var status = ""
    var statusLabel = ""
    var scheduledStart = ""
    var description: String?
    var canJoin = false
    var isExternal = false
    var meetingURL: String?
    var canEnd = false
    var rows: [SessionRow] = []
    var attendanceNote: String?
    var labels: [String: String] = [:]

    struct SessionRow: Decodable, Sendable, Equatable {
        var label: String
        var value: String
    }

    enum CodingKeys: String, CodingKey {
        case id, title, when, status, description, rows, labels
        case statusLabel = "status_label", scheduledStart = "scheduled_start"
        case canJoin = "can_join", isExternal = "is_external", meetingURL = "meeting_url"
        case canEnd = "can_end", attendanceNote = "attendance_note"
    }

    init(id: String) { self.id = id }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = c.lenient(.title, "")
        when = c.lenient(.when, "")
        status = c.lenient(.status, "")
        statusLabel = c.lenient(.statusLabel, "")
        scheduledStart = c.lenient(.scheduledStart, "")
        description = c.lenient(.description)
        canJoin = c.lenient(.canJoin, false)
        isExternal = c.lenient(.isExternal, false)
        meetingURL = c.lenient(.meetingURL)
        canEnd = c.lenient(.canEnd, false)
        rows = c.lenient(.rows, [])
        attendanceNote = c.lenient(.attendanceNote)
        labels = c.lenient(.labels, [:])
    }
}

// MARK: - Join ticket (`GET /mobile/conference/{id}/join`) — camelCase

struct JoinResponse: Decodable, Sendable {
    var success = false
    var data: JoinTicket?
    var error: String?

    enum CodingKeys: String, CodingKey { case success, data, error }

    init(success: Bool = false, data: JoinTicket? = nil, error: String? = nil) {
        self.success = success; self.data = data; self.error = error
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        success = c.lenient(.success, false)
        data = c.lenient(.data)
        error = c.lenient(.error)
    }
}

/// What the school switches on for the room (`roomConfig` of the ticket).
struct RoomTools: Decodable, Sendable, Equatable {
    var chat = true
    var hands = true
    var studentShare = false
    var joinMuted = false

    private struct Tools: Decodable {
        var chat: Bool?, hands: Bool?, studentShare: Bool?
        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: Keys.self)
            chat = c.lenient(.chat); hands = c.lenient(.hands); studentShare = c.lenient(.studentShare)
        }
        enum Keys: String, CodingKey { case chat, hands, studentShare }
    }

    enum CodingKeys: String, CodingKey { case tools, joinMuted }

    init(chat: Bool = true, hands: Bool = true, studentShare: Bool = false, joinMuted: Bool = false) {
        self.chat = chat; self.hands = hands; self.studentShare = studentShare; self.joinMuted = joinMuted
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let tools: Tools? = c.lenient(.tools)
        chat = tools?.chat ?? true
        hands = tools?.hands ?? true
        studentShare = tools?.studentShare ?? false
        joinMuted = c.lenient(.joinMuted, false)
    }
}

struct JoinTicket: Decodable, Sendable {
    var token: String
    var wsUrl: String
    var roomName: String
    var identity: String
    var role: String
    var hostIdentity: String?
    var roomConfig: RoomTools?
    var expiresAt: String

    enum CodingKeys: String, CodingKey {
        case token, wsUrl, roomName, identity, role, hostIdentity, roomConfig, expiresAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        token = try c.decode(String.self, forKey: .token)
        wsUrl = try c.decode(String.self, forKey: .wsUrl)
        roomName = c.lenient(.roomName, "")
        identity = c.lenient(.identity, "")
        role = c.lenient(.role, "")
        hostIdentity = c.lenient(.hostIdentity)
        roomConfig = c.lenient(.roomConfig)
        expiresAt = c.lenient(.expiresAt, "")
    }

    /// HOST and CO_HOST run the class; PARTICIPANT and VIEWER attend it.
    var isHost: Bool { role == "HOST" || role == "CO_HOST" }
}

// MARK: - Chat (`/mobile/conference/{id}/chat`)

struct RoomChatMessage: Decodable, Sendable, Equatable {
    var id: String
    var identity: String
    var name = ""
    var text: String
    /// Epoch ms.
    var at: Int64

    enum CodingKeys: String, CodingKey { case id, identity, name, text, at }

    init(id: String, identity: String, name: String = "", text: String, at: Int64) {
        self.id = id; self.identity = identity; self.name = name; self.text = text; self.at = at
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        identity = try c.decode(String.self, forKey: .identity)
        name = c.lenient(.name, "")
        text = try c.decode(String.self, forKey: .text)
        at = try c.decode(Int64.self, forKey: .at)
    }
}

struct RoomChatResponse: Decodable, Sendable {
    var success = false
    var messages: [RoomChatMessage] = []
    var hasMore = false
    var error: String?

    enum CodingKeys: String, CodingKey { case success, data, error }
    enum DataKeys: String, CodingKey { case messages, hasMore }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        success = c.lenient(.success, false)
        error = c.lenient(.error)
        if let d = try? c.nestedContainer(keyedBy: DataKeys.self, forKey: .data) {
            // Drop a single malformed message rather than the whole page.
            messages = d.lenientArray(.messages)
            hasMore = d.lenient(.hasMore, false)
        }
    }
}

/// Decodes to nil instead of throwing, so one bad array element doesn't sink the array.
struct LossyBox<T: Decodable>: Decodable {
    let value: T?
    init(from decoder: Decoder) throws { value = try? T(from: decoder) }
}

// MARK: - Requests / results

struct RecordChatRequest: Encodable, Sendable {
    let messageId: String
    let text: String
}

struct MuteRequest: Encodable, Sendable {
    var identity: String?
}

struct SimpleResult: Decodable, Sendable {
    var success = false
    var error: String?

    enum CodingKeys: String, CodingKey { case success, error }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        success = c.lenient(.success, false)
        error = c.lenient(.error)
    }
}
