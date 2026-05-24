import SwiftUI

/// iOS WhatsApp-style chat / messages screen.
/// Mirrors Figma: EKtlCVUnSrIQ8G8fO0msMu node 86:6042 (Messages - Full view)
struct WaMessagesView: View {
    let contactName: String
    var contactSubtitle: String = "tap here for contact info"
    var contactAvatarUrl: String? = nil
    var unreadCount: Int? = nil
    let items: [WaChatItem]
    var onBack: () -> Void = {}
    var onVideo: () -> Void = {}
    var onPhone: () -> Void = {}
    var onTapInfo: () -> Void = {}
    var onSend: (String) -> Void = { _ in }

    @State private var messageText: String = ""
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        VStack(spacing: 0) {
            WaTopContactHeader(
                name: contactName,
                subtitle: contactSubtitle,
                avatarUrl: contactAvatarUrl,
                unreadCount: unreadCount,
                onBack: onBack,
                onVideo: onVideo,
                onPhone: onPhone,
                onTapInfo: onTapInfo
            )

            ZStack {
                Color(red: 0.961, green: 0.949, blue: 0.922) // #F5F2EB
                    .ignoresSafeArea()
                AsyncImage(url: URL(string: "https://d1dlwtcfl0db67.cloudfront.net/wallpapers/wp-wa-chat-bg.svg")) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.clear
                }
                .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items) { item in
                            renderItem(item)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)

            WaInputBar(
                text: $messageText,
                onSend: {
                    let t = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !t.isEmpty { onSend(t); messageText = "" }
                }
            )
        }
    }

    @ViewBuilder
    private func renderItem(_ item: WaChatItem) -> some View {
        switch item {
        case .date(_, let label):
            WaDateSeparator(label: label)
        case .text(_, let side, let text, let time, let status, let senderName, let tail, let reactions):
            VStack(spacing: 0) {
                WaMessageBubble(side: side, text: text, time: time, status: status, tail: tail, senderName: senderName)
                if !reactions.isEmpty {
                    WaReactionCluster(emojis: reactions, side: side)
                }
            }
        case .reply(_, let side, let text, let time, let status, let replySenderName, let replyText):
            WaReplyBubble(side: side, text: text, time: time, status: status, replySenderName: replySenderName, replyText: replyText)
        case .voice(_, let side, let avatarFallback, let durationLabel, let time, let status):
            WaVoiceNoteBubble(side: side, avatarFallback: avatarFallback, durationLabel: durationLabel, time: time, status: status)
        case .location(_, let side, let time, let status):
            WaLocationBubble(side: side, time: time, status: status)
        }
    }
}

// MARK: - Top Contact Header

struct WaTopContactHeader: View {
    let name: String
    let subtitle: String
    let avatarUrl: String?
    let unreadCount: Int?
    let onBack: () -> Void
    let onVideo: () -> Void
    let onPhone: () -> Void
    let onTapInfo: () -> Void

    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(wa.surfaceProduct)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)

            if let unreadCount, unreadCount > 0 {
                Text("\(unreadCount)")
                    .font(.system(size: 16.8, weight: .medium))
                    .foregroundStyle(wa.textPrimary)
                    .padding(.trailing, 4)
            }

            Button(action: onTapInfo) {
                HStack(spacing: 10) {
                    Circle().fill(wa.textSecondary.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text(String(name.prefix(1)).uppercased())
                                .foregroundStyle(.white)
                                .font(.system(size: 14, weight: .semibold))
                        )
                    VStack(alignment: .leading, spacing: 0) {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(wa.textPrimary)
                            .lineLimit(1)
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(wa.textSecondaryAlpha)
                            .lineLimit(1)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button(action: onVideo) {
                Image(systemName: "video.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(wa.surfaceProduct)
                    .frame(width: 32, height: 32)
            }.buttonStyle(.plain)

            Button(action: onPhone) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(wa.surfaceProduct)
                    .frame(width: 32, height: 32)
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .frame(height: 98)
        .background(wa.surfacePanel.background(.ultraThinMaterial))
        .overlay(alignment: .bottom) {
            Rectangle().fill(wa.borderPanel).frame(height: 0.33)
        }
    }
}

// MARK: - Input Bar

struct WaReplyDraft {
    let senderName: String
    let text: String
    let onClose: () -> Void
}

struct WaInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    var replyDraft: WaReplyDraft? = nil
    @Environment(\.whatsAppColors) private var wa
    @State private var hasFocus: Bool = false

    var hasText: Bool { !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            if let reply = replyDraft {
                HStack(alignment: .top, spacing: 0) {
                    Rectangle().fill(wa.borderQuote).frame(width: 4)
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 1.5) {
                            Text(reply.senderName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(wa.textQuoteTitle)
                                .lineLimit(1)
                            Text(reply.text)
                                .font(.system(size: 12))
                                .foregroundStyle(wa.textPrimary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Button(action: reply.onClose) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(wa.textSecondary)
                        }.buttonStyle(.plain)
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 7.5)
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .bottom, spacing: 8) {
                Button {} label: {
                    Image(systemName: "plus").font(.system(size: 20, weight: .medium))
                        .foregroundStyle(wa.surfaceProduct).frame(width: 32, height: 32)
                }.buttonStyle(.plain)

                HStack(alignment: .bottom, spacing: 16) {
                    TextField("Message", text: $text, axis: .vertical)
                        .font(.system(size: 16))
                        .foregroundStyle(wa.textPrimary)
                        .lineLimit(1...5)
                    Button {} label: {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 18))
                            .foregroundStyle(wa.textSecondary)
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(wa.surfaceInputChat)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(wa.borderInputChat, lineWidth: 0.33))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                if hasText {
                    Button(action: onSend) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(wa.textInvert)
                            .frame(width: 32, height: 32)
                            .background(wa.surfaceProduct)
                            .clipShape(Circle())
                    }.buttonStyle(.plain)
                } else {
                    HStack(spacing: 7) {
                        Button {} label: {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(wa.surfaceProduct)
                                .frame(width: 32, height: 32)
                        }.buttonStyle(.plain)
                        Button {} label: {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(wa.surfaceProduct)
                                .frame(width: 32, height: 32)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .padding(.leading, 7).padding(.trailing, 9).padding(.vertical, 5.5)

            // Home indicator
            Capsule()
                .fill(wa.surfaceInvert)
                .frame(width: 140, height: 5)
                .padding(.top, 21).padding(.bottom, 8)
        }
        .background(wa.surfacePanel.background(.ultraThinMaterial))
    }
}

#Preview("EN Light") {
    WaMessagesView(
        contactName: "Emmett \"Doc\" Br",
        unreadCount: 1,
        items: [
            .date(id: "d1", label: "Yesterday"),
            .voice(id: "v1", side: .me, avatarFallback: "M", durationLabel: "0:25", time: "22:30", status: .read),
            .date(id: "d2", label: "Today"),
            .text(id: "m1", side: .other, text: "Marty?", time: "08:21"),
            .text(id: "m2", side: .me, text: "Hey, hey, Doc, where are you?", time: "08:21", status: .read),
            .text(id: "m3", side: .other, text: "Thank God I found you.", time: "08:21", tail: false),
            .text(id: "m5", side: .me, text: "Wait a minute, wait a minute. 1:15 in the morning?", time: "08:21", status: .read),
            .reply(id: "r1", side: .other, text: "Yes. In the morning. 😃", time: "08:21", replySenderName: "You", replyText: "Wait a minute, wait a minute. 1:15 in the morning?"),
            .text(id: "m13", side: .me, text: "Yeah, I'll keep that in mind…", time: "08:23", status: .read, reactions: ["❤️", "❤️", "❤️"]),
            .location(id: "l1", side: .me, time: "08:24", status: .read),
        ]
    )
    .environment(\.whatsAppColors, .light)
}
