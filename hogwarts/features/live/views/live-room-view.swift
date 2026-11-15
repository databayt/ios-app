import LiveKit
import SwiftUI

// Palette from the Android room (and the web's room chrome).
private enum RoomColor {
    static let live = Color(red: 1, green: 0.231, blue: 0.188)          // #FF3B30
    static let speaking = Color(red: 0.204, green: 0.78, blue: 0.349)   // #34C759
    static let muted = Color(red: 0.863, green: 0.149, blue: 0.149).opacity(0.85) // #DC2626 @ .85
    static let cameraOffGlyph = Color(red: 0.973, green: 0.443, blue: 0.443)      // #F87171
    static let handRaised = Color(red: 0.984, green: 0.749, blue: 0.141)          // #FBBF24
    static let sharing = Color(red: 0.008, green: 0.518, blue: 0.78).opacity(0.9) // #0284C7 @ .9
}

/// `/live/[id]/room`, native. Black stage, tiles, top bar and the control row
/// (camera · mic · hand · share · chat) — Android's order and colours.
struct LiveRoomView: View {
    @State private var viewModel: LiveRoomViewModel
    @State private var showChat = false
    @State private var showHands = false
    private let onClose: () -> Void

    init(sessionId: String, title: String, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: LiveRoomViewModel(sessionId: sessionId, title: title))
        self.onClose = onClose
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch viewModel.phase {
            case .joining:
                VStack(spacing: 12) {
                    ProgressView().tint(.white)
                    Text(String(localized: "live.room.joining")).foregroundStyle(.white.opacity(0.7))
                }
            case .failed(let code):
                message(refusal(code), primary: nil)
            case .external(let url):
                message(String(localized: "live.room.external"),
                        primary: url.flatMap(URL.init(string:)).map { (String(localized: "live.room.openMeeting"), $0) })
            case .ended(let why):
                endedView(why)
            case .connected, .reconnecting:
                connectedStage
            }
        }
        .preferredColorScheme(.dark)
        .task { viewModel.join() }
        .onDisappear { viewModel.leave() }
        .sheet(isPresented: $showChat, onDismiss: { viewModel.setChatOpen(false) }) {
            LiveChatSheet(viewModel: viewModel)
                .onAppear { viewModel.setChatOpen(true) }
        }
        .sheet(isPresented: $showHands) {
            LiveHandsSheet(viewModel: viewModel)
        }
    }

    // MARK: Stage

    private var connectedStage: some View {
        ZStack {
            stage
            VStack(spacing: 0) {
                topBar
                if let notice = viewModel.notice {
                    noticePill(text(for: notice))
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 8)
                }
                Spacer()
                controls
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.notice)
        }
    }

    @ViewBuilder
    private var stage: some View {
        if viewModel.shareIsMine {
            VStack(spacing: 16) {
                Image(systemName: "rectangle.on.rectangle")
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
                Text(String(localized: "live.room.sharingNow"))
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
        } else if let share = viewModel.shareTrack {
            SwiftUIVideoView(share, layoutMode: .fit)
                .ignoresSafeArea()
        } else if viewModel.tiles.count == 1, viewModel.tiles[0].isLocal, viewModel.tiles[0].camera == nil {
            Text(String(localized: "live.room.alone"))
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 24)
        } else {
            tileGrid
        }
    }

    private var tileGrid: some View {
        let tiles = viewModel.tiles
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: tiles.count <= 1 ? 1 : 2)
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(tiles) { tile in
                    LiveTileView(tile: tile, youLabel: String(localized: "live.room.you"),
                                 hostLabel: String(localized: "live.room.host"))
                        .aspectRatio(tiles.count <= 1 ? 3.0 / 4.0 : 1, contentMode: .fit)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 72)
            .padding(.bottom, 100)
        }
    }

    // MARK: Chrome

    private var topBar: some View {
        HStack(spacing: 8) {
            Text(viewModel.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
            Text(String(localized: "live.room.live"))
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .background(RoomColor.live, in: Capsule())
            if viewModel.phase == .reconnecting {
                Text(String(localized: "live.room.reconnecting"))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            Spacer(minLength: 0)
            HWGlassDisc(systemImage: "xmark", accessibilityLabel: "live.room.leave", size: 40) {
                viewModel.leave()
                onClose()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func noticePill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .environment(\.colorScheme, .dark)
            .onTapGesture { viewModel.dismissNotice() }
    }

    private var controls: some View {
        HStack(spacing: 10) {
            HWGlassDisc(
                systemImage: viewModel.cameraOn ? "video" : "video.slash",
                accessibilityLabel: "live.room.camera",
                glyph: viewModel.cameraOn ? .white : RoomColor.cameraOffGlyph
            ) { viewModel.toggleCamera() }

            HWGlassDisc(
                systemImage: viewModel.micOn ? "mic" : "mic.slash",
                accessibilityLabel: "live.room.mic",
                fill: viewModel.micOn ? nil : RoomColor.muted
            ) { viewModel.toggleMic() }

            if viewModel.tools.hands {
                if viewModel.isHost {
                    HWGlassDisc(
                        systemImage: "hand.raised",
                        accessibilityLabel: "live.room.hands",
                        badge: viewModel.hands.isEmpty ? nil : "\(viewModel.hands.count)"
                    ) { showHands = true }
                } else {
                    HWGlassDisc(
                        systemImage: viewModel.handUp ? "hand.raised.fill" : "hand.raised",
                        accessibilityLabel: viewModel.handUp ? "live.room.lowerHand" : "live.room.raiseHand",
                        fill: viewModel.handUp ? RoomColor.handRaised : nil,
                        glyph: viewModel.handUp ? .black : .white
                    ) { viewModel.setHand(!viewModel.handUp) }
                }
            } else if viewModel.isHost {
                // Mute-all lives in the Hands sheet; without hands the host still needs it.
                HWGlassDisc(systemImage: "hand.raised", accessibilityLabel: "live.room.hands") { showHands = true }
            }

            if viewModel.canShare {
                HWGlassDisc(
                    systemImage: viewModel.shareOn ? "rectangle.on.rectangle.slash" : "rectangle.on.rectangle",
                    accessibilityLabel: viewModel.shareOn ? "live.room.stopShare" : "live.room.share",
                    fill: viewModel.shareOn ? RoomColor.sharing : nil
                ) { viewModel.toggleShare() }
            }

            if viewModel.tools.chat {
                HWGlassDisc(
                    systemImage: "bubble.left",
                    accessibilityLabel: "live.room.chat",
                    badge: viewModel.chatUnread > 0 ? "\(viewModel.chatUnread)" : nil
                ) { showChat = true }
            }
        }
        .padding(.bottom, 24)
    }

    // MARK: Terminal states

    private func endedView(_ why: LiveRoomPhase.Why) -> some View {
        Group {
            switch why {
            case .left:
                Color.clear.onAppear { onClose() }
            case .removed: message(String(localized: "live.room.removed"), primary: nil)
            case .elsewhere: message(String(localized: "live.room.elsewhere"), primary: nil)
            case .ended: message(String(localized: "live.room.ended"), primary: nil)
            case .lost: message(String(localized: "live.room.connectionLost"), primary: nil, rejoin: true)
            }
        }
    }

    private func message(_ text: String, primary: (String, URL)?, rejoin: Bool = false) -> some View {
        VStack(spacing: 20) {
            Text(text)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            if let primary {
                Link(primary.0, destination: primary.1)
                    .buttonStyle(.borderedProminent)
            }
            if rejoin {
                Button(String(localized: "live.room.rejoin")) { viewModel.join() }
                    .buttonStyle(.borderedProminent)
            }
            Button(String(localized: "live.room.backToClass")) { onClose() }
                .buttonStyle(.bordered)
        }
        .padding(32)
    }

    // MARK: Strings

    private func text(for notice: RoomNotice) -> String {
        switch notice {
        case .handRaised(let name): String(format: String(localized: "live.room.handRaisedBy"), name)
        case .handLowered: String(localized: "live.room.handLowered")
        case .mutedByHost: String(localized: "live.room.mutedByHost")
        case .mutedAll: String(localized: "live.room.mutedAll")
        case .shareFailed: String(localized: "live.room.shareFailed")
        case .micFailed: String(localized: "live.room.micFailed")
        case .cameraFailed: String(localized: "live.room.cameraFailed")
        }
    }

    private func refusal(_ code: String?) -> String {
        switch code {
        case "NOT_AUTHENTICATED": String(localized: "live.err.notAuthenticated")
        case "MISSING_SCHOOL", "SCHOOL_NOT_FOUND": String(localized: "live.err.missingSchool")
        case "UNAUTHORIZED": String(localized: "live.err.unauthorized")
        case "LIVE_CLASS_NOT_FOUND": String(localized: "live.err.notFound")
        case "LIVE_CLASS_PARTICIPANT_DENIED": String(localized: "live.err.participantDenied")
        case "LIVE_CLASS_INVALID_STATE": String(localized: "live.err.invalidState")
        case "LIVE_CLASS_PROVIDER_UNAVAILABLE": String(localized: "live.err.providerUnavailable")
        case "LIVE_CLASS_MAX_CONCURRENT": String(localized: "live.err.maxConcurrent")
        case "LIVE_CLASS_ROOM_FULL": String(localized: "live.err.roomFull")
        default: String(localized: "live.err.tokenFailed")
        }
    }
}

// MARK: - Tile

private struct LiveTileView: View {
    let tile: RoomTile
    let youLabel: String
    let hostLabel: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.08))
            if let camera = tile.camera {
                SwiftUIVideoView(camera, layoutMode: .fill, mirrorMode: tile.isLocal ? .mirror : .off)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                Text(String(tile.name.first ?? "?").uppercased())
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack(spacing: 6) {
                if !tile.micOn {
                    Image(systemName: "mic.slash.fill").font(.caption2).foregroundStyle(.white)
                        .padding(4).background(Color.red.opacity(0.85), in: Circle())
                }
                if tile.handUp {
                    Image(systemName: "hand.raised.fill").font(.caption2).foregroundStyle(.black)
                        .padding(4).background(RoomColor.handRaised, in: Circle())
                }
                Text(label)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(.black.opacity(0.45), in: Capsule())
            .padding(8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(RoomColor.speaking, lineWidth: tile.speaking ? 3 : 0)
        }
        .accessibilityElement(children: .combine)
    }

    private var label: String {
        if tile.isLocal { return youLabel }
        return tile.isHost ? "\(tile.name) · \(hostLabel)" : tile.name
    }
}

// MARK: - Chat sheet

private struct LiveChatSheet: View {
    let viewModel: LiveRoomViewModel
    @State private var draft = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.chat.isEmpty {
                    Text(String(localized: "live.room.noMessages"))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.chat) { line in
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 6) {
                                            Text(line.mine ? String(localized: "live.room.you") : line.name)
                                                .font(.caption.weight(.semibold))
                                            Text(Date(timeIntervalSince1970: Double(line.at) / 1000),
                                                 format: .dateTime.hour().minute())
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        Text(line.text).font(.body)
                                    }
                                    .id(line.id)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: viewModel.chat.count) {
                            if let last = viewModel.chat.last { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                Divider()
                HStack(spacing: 8) {
                    TextField(String(localized: "live.room.messagePlaceholder"), text: $draft, axis: .vertical)
                        .lineLimit(1...4)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        viewModel.sendChat(draft)
                        draft = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill").font(.title2)
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel(String(localized: "live.room.send"))
                }
                .padding()
            }
            .navigationTitle(String(localized: "live.room.chat"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "live.room.close")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - Hands sheet (host)

private struct LiveHandsSheet: View {
    let viewModel: LiveRoomViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.hands.isEmpty {
                        Text(String(localized: "live.room.noHands")).foregroundStyle(.secondary)
                    }
                    ForEach(viewModel.hands) { hand in
                        HStack {
                            Image(systemName: "hand.raised.fill").foregroundStyle(RoomColor.handRaised)
                            Text(hand.name)
                            Spacer()
                            if viewModel.canLowerHands {
                                Button(String(localized: "live.room.clearHand")) {
                                    viewModel.lowerHand(of: hand.identity)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                if viewModel.canLowerHands && !viewModel.hands.isEmpty {
                    Section {
                        Button(String(localized: "live.room.lowerAll")) { viewModel.lowerAllHands() }
                    }
                }
                if viewModel.canMuteAll {
                    Section {
                        Button {
                            viewModel.muteAll()
                            dismiss()
                        } label: {
                            Label(String(localized: "live.room.muteAll"), systemImage: "mic.slash")
                        }
                    }
                }
            }
            .navigationTitle(String(localized: "live.room.hands"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "live.room.close")) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
