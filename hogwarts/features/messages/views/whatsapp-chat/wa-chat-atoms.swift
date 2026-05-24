import SwiftUI

// MARK: - Data Model

enum WaBubbleStatus { case sent, delivered, read }

enum WaChatItem: Identifiable {
    case date(id: String, label: String)
    case text(id: String, side: WaSide, text: String, time: String, status: WaBubbleStatus? = nil, senderName: String? = nil, tail: Bool = true, reactions: [String] = [])
    case reply(id: String, side: WaSide, text: String, time: String, status: WaBubbleStatus? = nil, replySenderName: String, replyText: String)
    case voice(id: String, side: WaSide, avatarFallback: String = "?", durationLabel: String, time: String, status: WaBubbleStatus? = nil)
    case location(id: String, side: WaSide, time: String, status: WaBubbleStatus? = nil)

    var id: String {
        switch self {
        case .date(let id, _), .text(let id, _, _, _, _, _, _, _),
             .reply(let id, _, _, _, _, _, _),
             .voice(let id, _, _, _, _, _),
             .location(let id, _, _, _): return id
        }
    }
}

enum WaSide { case me, other }

// MARK: - Tail Shape

struct WaBubbleTail: View {
    let side: WaSide
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        Canvas { ctx, _ in
            var path = Path()
            path.move(to: CGPoint(x: 7.5, y: 4))
            path.addLine(to: CGPoint(x: 7.5, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 14))
            path.addCurve(to: CGPoint(x: 13.1, y: 17.97), control1: CGPoint(x: 3.66, y: 17.25), control2: CGPoint(x: 10.63, y: 17.86))
            path.addCurve(to: CGPoint(x: 13.35, y: 17.38), control1: CGPoint(x: 13.41, y: 17.99), control2: CGPoint(x: 13.56, y: 17.6))
            path.addCurve(to: CGPoint(x: 7.5, y: 4), control1: CGPoint(x: 11.7, y: 15.73), control2: CGPoint(x: 7.5, y: 10.83))
            path.closeSubpath()
            let color = side == .me ? wa.surfaceBaloonMe : wa.surfaceBaloonOther
            ctx.fill(path, with: .color(color))
        }
        .frame(width: 15, height: 18)
        .scaleEffect(x: side == .me ? 1 : -1, y: 1)
    }
}

// MARK: - Timestamp + Status

struct WaBubbleTimestamp: View {
    let time: String
    let status: WaBubbleStatus?
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack(spacing: 2) {
            Text(time)
                .font(.system(size: 11))
                .tracking(0.55)
                .foregroundStyle(wa.textSecondaryAlpha)
            if let status {
                statusIcon(status)
                    .frame(width: 17, height: 17)
                    .foregroundStyle(status == .read ? Color(red: 0.325, green: 0.741, blue: 0.922) : wa.textSecondaryAlpha)
            }
        }
    }

    @ViewBuilder
    private func statusIcon(_ s: WaBubbleStatus) -> some View {
        // Double-check glyph drawn as Path; WhatsApp style.
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            var p = Path()
            p.move(to: CGPoint(x: 0.9 * 0.5, y: 0.5 * h))
            p.addLine(to: CGPoint(x: 0.3 * w, y: 0.7 * h))
            p.addLine(to: CGPoint(x: 0.8 * w, y: 0.15 * h))
            var p2 = Path()
            p2.move(to: CGPoint(x: 0.3 * w, y: 0.5 * h))
            p2.addLine(to: CGPoint(x: 0.55 * w, y: 0.72 * h))
            p2.addLine(to: CGPoint(x: 1.0 * w, y: 0.15 * h))
            ctx.stroke(p, with: .color(.primary), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))
            ctx.stroke(p2, with: .color(.primary), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Date Separator

struct WaDateSeparator: View {
    let label: String
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack { Spacer()
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(wa.textPrimary)
                .frame(minWidth: 100)
                .padding(.horizontal, 14)
                .padding(.vertical, 3)
                .background(wa.surfaceDate)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(wa.surfaceShadowBaloon, lineWidth: 0.66))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Spacer()
        }
        .padding(.top, 23)
    }
}

// MARK: - Text Message Bubble

struct WaMessageBubble: View {
    let side: WaSide
    let text: String
    let time: String
    let status: WaBubbleStatus?
    let tail: Bool
    let senderName: String?
    @Environment(\.whatsAppColors) private var wa

    init(side: WaSide, text: String, time: String, status: WaBubbleStatus? = nil, tail: Bool = true, senderName: String? = nil) {
        self.side = side; self.text = text; self.time = time
        self.status = status; self.tail = tail; self.senderName = senderName
    }

    var body: some View {
        HStack {
            if side == .me { Spacer(minLength: 0) }
            ZStack(alignment: side == .me ? .bottomTrailing : .bottomLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    if let senderName, side == .other {
                        Text(senderName)
                            .font(.system(size: 12.8, weight: .semibold))
                            .foregroundStyle(wa.textProduct)
                    }
                    Text(text)
                        .font(.system(size: 15.8))
                        .tracking(-0.21)
                        .foregroundStyle(wa.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing, side == .me ? 70 : 52)
                }
                .padding(.horizontal, 10)
                .padding(.top, 5.5)
                .padding(.bottom, 6.5)

                WaBubbleTimestamp(time: time, status: side == .me ? (status ?? .sent) : nil)
                    .padding(.bottom, 3)
                    .padding(.trailing, 8)

                if tail {
                    WaBubbleTail(side: side)
                        .offset(x: side == .me ? 7.5 : -7.5, y: 0)
                }
            }
            .frame(minWidth: 88, maxWidth: 287, alignment: .leading)
            .background(side == .me ? wa.surfaceBaloonMe : wa.surfaceBaloonOther)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(wa.surfaceShadowBaloon, lineWidth: 0.66))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if side == .other { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - Reply Bubble

struct WaReplyBubble: View {
    let side: WaSide
    let text: String
    let time: String
    let status: WaBubbleStatus?
    let replySenderName: String
    let replyText: String
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack {
            if side == .me { Spacer(minLength: 0) }
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Rectangle().fill(Color(red: 0.855, green: 0.31, blue: 0.478)).frame(width: 4)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(replySenderName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(red: 0.855, green: 0.31, blue: 0.478))
                            Text(replyText)
                                .font(.system(size: 13.2))
                                .foregroundStyle(wa.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(minWidth: 200)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))

                    Text(text)
                        .font(.system(size: 15.8))
                        .foregroundStyle(wa.textPrimary)
                        .padding(.horizontal, 4)
                        .padding(.trailing, side == .me ? 70 : 52)
                }
                .padding(.horizontal, 6)
                .padding(.top, 5)
                .padding(.bottom, 6.5)

                WaBubbleTimestamp(time: time, status: side == .me ? (status ?? .sent) : nil)
                    .padding(.bottom, 3)
                    .padding(.trailing, 8)
            }
            .frame(maxWidth: 287)
            .background(side == .me ? wa.surfaceBaloonMe : wa.surfaceBaloonOther)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if side == .other { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - Voice Note Bubble

struct WaVoiceNoteBubble: View {
    let side: WaSide
    let avatarFallback: String
    let durationLabel: String
    let time: String
    let status: WaBubbleStatus?
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack {
            if side == .me { Spacer(minLength: 0) }
            HStack(spacing: 10) {
                Circle().fill(wa.textSecondary.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .overlay(Text(avatarFallback).foregroundStyle(.white).font(.system(size: 14, weight: .semibold)))
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(wa.textPrimary)
                    .frame(width: 24, height: 24)
                HStack(spacing: 2) {
                    ForEach(0..<26, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(wa.textSecondaryAlpha)
                            .frame(width: 2, height: CGFloat([5, 9, 14, 20, 16, 10, 7, 12, 18, 22, 16, 9, 6, 12, 18, 20, 14, 8, 5, 10, 16, 22, 18, 12, 7, 5][i % 26]))
                    }
                }
                .frame(height: 28)
                Text(durationLabel)
                    .font(.system(size: 11))
                    .foregroundStyle(wa.textSecondaryAlpha)
            }
            .frame(width: 287)
            .padding(8)
            .background(side == .me ? wa.surfaceBaloonMe : wa.surfaceBaloonOther)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if side == .other { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - Location Bubble

struct WaLocationBubble: View {
    let side: WaSide
    let time: String
    let status: WaBubbleStatus?
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack {
            if side == .me { Spacer(minLength: 0) }
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 240, height: 130)
                    .overlay(
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.red)
                    )
                WaBubbleTimestamp(time: time, status: side == .me ? (status ?? .sent) : nil)
                    .padding(.horizontal, 4).padding(.vertical, 2)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .padding(.bottom, 6).padding(.trailing, 8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(width: 240)
            if side == .other { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - Reactions

struct WaReactionCluster: View {
    let emojis: [String]
    let side: WaSide
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack {
            if side == .me { Spacer(minLength: 0) }
            HStack(spacing: 2) {
                ForEach(Array(emojis.enumerated()), id: \.offset) { _, e in
                    Text(e).font(.system(size: 12))
                }
            }
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(wa.surfaceBaloonOther)
            .overlay(Capsule().stroke(wa.surfaceShadowBaloon, lineWidth: 0.66))
            .clipShape(Capsule())
            if side == .other { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }
}
