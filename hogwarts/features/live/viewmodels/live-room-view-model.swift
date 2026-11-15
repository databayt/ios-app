import Foundation
import LiveKit
import Observation

/// One person in the room, as a tile draws them.
struct RoomTile: Identifiable {
    let id: String
    let name: String
    let isLocal: Bool
    let isHost: Bool
    let camera: VideoTrack?
    let micOn: Bool
    let speaking: Bool
    let handUp: Bool
}

enum LiveRoomPhase: Equatable {
    case joining
    /// The join was refused; carries `performLiveClassJoin`'s error code.
    case failed(code: String?)
    case connected
    case reconnecting
    case ended(Why)
    /// An external-link class has no SFU room: the web hands the viewer to the vendor meeting.
    case external(url: String?)

    enum Why: Equatable { case ended, removed, elsewhere, lost, left }
}

/// One chat line — live (`lk.chat` text stream) or from the saved history.
struct ChatLine: Identifiable, Equatable {
    let id: String
    let identity: String
    let name: String
    let text: String
    let at: Int64
    let mine: Bool
}

/// A raised hand, in the order it went up.
struct HandLine: Identifiable, Equatable {
    var id: String { identity }
    let identity: String
    let name: String
}

/// A passing notice over the stage (the web's room toasts).
enum RoomNotice: Equatable {
    case handRaised(String)
    case handLowered
    case mutedByHost
    case mutedAll
    case shareFailed
    case micFailed
    case cameraFailed
}

/// `/live/[id]/room`, native: the ticket from `performLiveClassJoin`, then LiveKit.
/// Ported from Android `live-room-view-model.kt`. The phone joins with microphone and camera off
/// (like Android) and turns each on the first time the user asks.
@MainActor
@Observable
final class LiveRoomViewModel: NSObject, RoomDelegate {
    let sessionId: String
    @ObservationIgnored let room: Room
    @ObservationIgnored private let actions: LiveActions

    // State the view reads.
    private(set) var phase: LiveRoomPhase = .joining
    private(set) var title = ""
    private(set) var tiles: [RoomTile] = []
    /// A screen share fills the stage when there is one (a remote one, or ours placeholder-ed).
    private(set) var shareTrack: VideoTrack?
    /// This phone is the one sharing: the stage says so instead of mirroring itself.
    private(set) var shareIsMine = false
    private(set) var micOn = false
    private(set) var cameraOn = false
    private(set) var shareOn = false
    private(set) var sharePending = false
    private(set) var isHost = false
    private(set) var tools = RoomTools()
    private(set) var handUp = false
    private(set) var hands: [HandLine] = []
    private(set) var chat: [ChatLine] = []
    private(set) var chatUnread = 0
    private(set) var notice: RoomNotice?
    private(set) var isLocalSpeaker = false

    /// HOST / CO_HOST always; a student only with the school's student-share tool.
    var canShare: Bool { isHost || tools.studentShare }
    var canMuteAll: Bool { isHost }
    var canLowerHands: Bool { isHost }

    @ObservationIgnored private var hostIdentity: String?
    @ObservationIgnored private var roomHosts: Set<String> = []
    /// When this phone first saw each hand go up — the queue's tiebreak.
    @ObservationIgnored private var handSeen: [String: Int64] = [:]
    @ObservationIgnored private var chatOpen = false
    @ObservationIgnored private var noticeTask: Task<Void, Never>?
    @ObservationIgnored private var joinTask: Task<Void, Never>?
    @ObservationIgnored private var leaving = false

    init(sessionId: String, actions: LiveActions = LiveActions(), title: String = "") {
        self.sessionId = sessionId
        self.actions = actions
        self.title = title
        // A teacher's screen at 720p / 15 fps, as the web's `ScreenSharePresets.h720fps15`.
        // Broadcast capture reads these room defaults, not per-call options.
        let options = RoomOptions(
            defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(dimensions: .h720_169, fps: 15)
        )
        self.room = Room(roomOptions: options)
        super.init()
        room.add(delegate: self)
    }

    // MARK: - Join

    func join() {
        joinTask?.cancel()
        leaving = false
        phase = .joining
        joinTask = Task { [weak self] in await self?.runJoin() }
    }

    private func runJoin() async {
        if let page = try? await actions.session(id: sessionId) {
            if !page.title.isEmpty { title = page.title }
            if page.isExternal {
                phase = .external(url: page.meetingURL)
                return
            }
        }
        let result: JoinResponse
        do {
            result = try await actions.join(id: sessionId)
        } catch {
            phase = .failed(code: nil)
            return
        }
        guard result.success, let ticket = result.data else {
            phase = .failed(code: result.error)
            return
        }
        hostIdentity = ticket.hostIdentity
        let roomTools = ticket.roomConfig ?? RoomTools()
        tools = roomTools
        isHost = ticket.isHost
        await listenForChat()
        do {
            try await room.connect(url: ticket.wsUrl, token: ticket.token)
        } catch {
            if !Task.isCancelled { phase = .failed(code: "LIVE_CLASS_PROVIDER_UNAVAILABLE") }
            return
        }
        guard !Task.isCancelled, !leaving else { return }
        roomHosts = ClassWire.roomHosts(metadata: room.metadata)
        phase = .connected
        refresh()
        // Joins with mic and camera off, so `joinMuted` is already honoured.
        if roomTools.chat { await loadChatHistory() }
    }

    // MARK: - Controls

    func toggleMic() {
        let want = !micOn
        Task {
            do { try await room.localParticipant.setMicrophone(enabled: want) }
            catch { show(.micFailed) }
            refresh()
        }
    }

    func toggleCamera() {
        let want = !cameraOn
        Task {
            do { try await room.localParticipant.setCamera(enabled: want) }
            catch { show(.cameraFailed) }
            refresh()
        }
    }

    /// Start or stop the screen share. On iOS < 27 with the broadcast extension this presents the
    /// system broadcast picker and publishes when the broadcast starts; on iOS 27+ it uses
    /// ScreenCaptureKit's picker. A dismissed picker is silent; anything else is a notice.
    func toggleShare() {
        if shareOn || sharePending {
            Task {
                _ = try? await room.localParticipant.setScreenShare(enabled: false)
                sharePending = false
                refresh()
            }
            return
        }
        guard canShare else { return }
        sharePending = true
        Task {
            defer { sharePending = false; refresh() }
            do {
                _ = try await room.localParticipant.setScreenShare(enabled: true)
            } catch {
                if Self.isUserCancel(error) { return }
                show(.shareFailed)
            }
        }
    }

    /// A closed picker/broadcast dialog says nothing (the web's `shareErrorMessage` → null).
    nonisolated static func isUserCancel(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if let lk = error as? LiveKitError, lk.type == .cancelled { return true }
        return false
    }

    /// Student: raise or lower the hand — the same attributes the web reads.
    func setHand(_ up: Bool) {
        handUp = up
        let attributes = ClassWire.handAttributes(up: up, nowMs: Self.nowMs())
        Task { try? await room.localParticipant.set(attributes: attributes) }
    }

    /// Host: lower one student's hand (`hand.clear`, addressed to that student).
    func lowerHand(of identity: String) {
        Task { await sendClass("hand.clear", to: [Participant.Identity(from: identity)]) }
    }

    func lowerAllHands() {
        Task { await sendClass("hand.clearAll") }
    }

    /// Host: mute every student server-side, then tell the class (the web host's `muted`).
    func muteAll() {
        Task {
            if await actions.muteAll(id: sessionId) {
                await sendClass("muted")
                show(.mutedAll)
            }
        }
    }

    func setChatOpen(_ open: Bool) {
        chatOpen = open
        if open { chatUnread = 0 }
    }

    func sendChat(_ raw: String) {
        let text = String(raw.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1000))
        guard !text.isEmpty else { return }
        Task {
            guard let info = try? await room.localParticipant.sendText(text, for: ClassWire.chatTopic) else { return }
            let me = room.localParticipant
            addChat(ChatLine(
                id: info.id, identity: me.identity?.stringValue ?? "",
                name: me.name ?? "", text: text,
                at: Int64(info.timestamp.timeIntervalSince1970 * 1000), mine: true
            ))
            // The memory, after the fact — the class already has the message.
            await actions.recordChat(id: sessionId, messageId: info.id, text: text)
        }
    }

    func dismissNotice() {
        noticeTask?.cancel()
        notice = nil
    }

    func leave() {
        leaving = true
        joinTask?.cancel()
        phase = .ended(.left)
        Task { await room.disconnect() }
    }

    // MARK: - Class channel

    private func sendClass(_ type: String, to: [Participant.Identity] = []) async {
        let options = DataPublishOptions(destinationIdentities: to, topic: ClassWire.classTopic, reliable: true)
        do {
            try await room.localParticipant.publish(data: ClassWire.encode(type), options: options)
        } catch {
            // Logged, never thrown into the UI.
            NSLog("LiveRoom: class message %@ not sent: %@", type, String(describing: error))
        }
    }

    private func onClassMessage(from sender: String?, data: Data) {
        guard ClassWire.isTrustedHost(sender: sender, hostIdentity: hostIdentity, roomHosts: roomHosts) else { return }
        switch ClassWire.type(of: data) {
        case "hand.clear", "hand.clearAll":
            let wasUp = room.localParticipant.attributes[ClassWire.handAttribute] == "1"
            handUp = false
            let attributes = ClassWire.handAttributes(up: false, nowMs: 0)
            Task { try? await room.localParticipant.set(attributes: attributes) }
            if wasUp { show(.handLowered) }
        case "muted":
            show(.mutedByHost)
        default:
            break // sync.request, board, polls… are not the phone's.
        }
    }

    // MARK: - Chat

    private func listenForChat() async {
        await room.unregisterTextStreamHandler(for: ClassWire.chatTopic)
        try? await room.registerTextStreamHandler(for: ClassWire.chatTopic) { [weak self] reader, from in
            guard let text = try? await reader.readAll() else { return }
            let id = reader.info.id
            let at = Int64(reader.info.timestamp.timeIntervalSince1970 * 1000)
            await self?.receivedChat(id: id, from: from.stringValue, text: text, at: at)
        }
    }

    private func receivedChat(id: String, from: String, text: String, at: Int64) {
        let who = room.remoteParticipants[Participant.Identity(from: from)]
        let name = who?.name.flatMap { $0.isEmpty ? nil : $0 } ?? from
        addChat(ChatLine(id: id, identity: from, name: name, text: text, at: at, mine: false))
    }

    private func loadChatHistory() async {
        let mine = room.localParticipant.identity?.stringValue
        let saved = await actions.chatHistory(id: sessionId).map {
            ChatLine(id: $0.id, identity: $0.identity, name: $0.name, text: $0.text, at: $0.at, mine: $0.identity == mine)
        }
        var seen = Set<String>()
        chat = (saved + chat).filter { seen.insert($0.id).inserted }.sorted { $0.at < $1.at }
    }

    private func addChat(_ line: ChatLine) {
        guard !chat.contains(where: { $0.id == line.id }) else { return }
        chat = (chat + [line]).sorted { $0.at < $1.at }
        if !line.mine && !chatOpen { chatUnread += 1 }
    }

    // MARK: - Projection of the room into view state

    func refresh() {
        let local = room.localParticipant
        let people: [Participant] = [local] + Array(room.remoteParticipants.values)
        var share: VideoTrack?
        var mine = false
        var built: [RoomTile] = []
        let now = Self.nowMs()
        var inputs: [ClassWire.HandInput] = []

        for p in people {
            let isLocal = p === local
            let identity = p.identity?.stringValue ?? ""
            if share == nil, !mine, let screen = p.firstScreenSharePublication, !screen.isMuted {
                // First sharer wins; our own screen is never drawn back onto itself.
                if isLocal { mine = true } else { share = screen.track as? VideoTrack }
            }
            let cam = p.firstCameraPublication
            let camera = (cam != nil && !(cam!.isMuted)) ? cam!.track as? VideoTrack : nil
            let up = p.attributes[ClassWire.handAttribute] == "1"
            if up { if handSeen[identity] == nil { handSeen[identity] = now } } else { handSeen[identity] = nil }
            let display = (p.name?.isEmpty == false ? p.name : nil) ?? identity
            inputs.append(.init(identity: identity, name: display, hand: p.attributes[ClassWire.handAttribute],
                                handAt: p.attributes[ClassWire.handAtAttribute], firstSeenMs: handSeen[identity] ?? now))
            built.append(RoomTile(
                id: p.sid?.stringValue ?? identity, name: display, isLocal: isLocal,
                isHost: !identity.isEmpty && identity == hostIdentity,
                camera: camera, micOn: p.isMicrophoneEnabled(), speaking: p.isSpeaking, handUp: up
            ))
        }

        tiles = built.sorted { a, b in
            if a.isHost != b.isHost { return a.isHost }
            if a.isLocal != b.isLocal { return !a.isLocal }
            return false
        }
        shareTrack = share
        shareIsMine = mine
        shareOn = mine
        micOn = local.isMicrophoneEnabled()
        cameraOn = local.isCameraEnabled()
        isLocalSpeaker = local.isSpeaking

        let queue = ClassWire.handQueue(inputs).map { HandLine(identity: $0.identity, name: $0.name) }
        let me = local.identity?.stringValue
        let newHand = queue.first { q in q.identity != me && !hands.contains { $0.identity == q.identity } }
        hands = queue
        handUp = queue.contains { $0.identity == me }
        if isHost, tools.hands, let newHand { show(.handRaised(newHand.name)) }
    }

    // MARK: - Notices

    private func show(_ notice: RoomNotice) {
        self.notice = notice
        noticeTask?.cancel()
        noticeTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(4))
            if !Task.isCancelled { self?.notice = nil }
        }
    }

    private static func nowMs() -> Int64 { Int64(Date().timeIntervalSince1970 * 1000) }

    // MARK: - RoomDelegate (called off the main actor)

    nonisolated func room(_ room: Room, didUpdateConnectionState connectionState: ConnectionState,
                          from oldConnectionState: ConnectionState) {
        Task { @MainActor in
            switch connectionState {
            case .reconnecting: if case .connected = self.phase { self.phase = .reconnecting }
            case .connected: if self.phase == .reconnecting { self.phase = .connected }
            default: break
            }
            self.refresh()
        }
    }

    nonisolated func room(_ room: Room, didDisconnectWithError error: LiveKitError?) {
        let why: LiveRoomPhase.Why
        switch error?.type {
        case .participantRemoved?: why = .removed
        case .duplicateIdentity?: why = .elsewhere
        case .roomDeleted?, .serverShutdown?: why = .ended
        case nil: why = .left
        default: why = .lost
        }
        Task { @MainActor in
            if case .ended = self.phase { return }
            if case .failed = self.phase { return }
            self.phase = .ended(why)
        }
    }

    nonisolated func room(_ room: Room, didUpdateMetadata metadata: String?) {
        let hosts = ClassWire.roomHosts(metadata: metadata)
        Task { @MainActor in self.roomHosts = hosts }
    }

    nonisolated func room(_ room: Room, participant: RemoteParticipant?, didReceiveData data: Data,
                          forTopic topic: String, encryptionType: EncryptionType) {
        guard topic == ClassWire.classTopic else { return }
        let sender = participant?.identity?.stringValue
        Task { @MainActor in self.onClassMessage(from: sender, data: data) }
    }

    nonisolated func room(_ room: Room, participantDidConnect participant: RemoteParticipant) { poke() }
    nonisolated func room(_ room: Room, participantDidDisconnect participant: RemoteParticipant) { poke() }
    nonisolated func room(_ room: Room, didUpdateSpeakingParticipants participants: [Participant]) { poke() }
    nonisolated func room(_ room: Room, participant: Participant, didUpdateName name: String) { poke() }
    nonisolated func room(_ room: Room, participant: Participant, didUpdateAttributes attributes: [String: String]) { poke() }
    nonisolated func room(_ room: Room, participant: LocalParticipant, didPublishTrack publication: LocalTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: LocalParticipant, didUnpublishTrack publication: LocalTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: RemoteParticipant, didPublishTrack publication: RemoteTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: RemoteParticipant, didUnpublishTrack publication: RemoteTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: RemoteParticipant, didUnsubscribeTrack publication: RemoteTrackPublication) { poke() }
    nonisolated func room(_ room: Room, participant: Participant, trackPublication: TrackPublication, didUpdateIsMuted isMuted: Bool) { poke() }

    private nonisolated func poke() {
        Task { @MainActor in self.refresh() }
    }
}
