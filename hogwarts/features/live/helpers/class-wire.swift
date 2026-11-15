import Foundation

/// The web room's wire, so a phone in the app and a laptop on the web sit in the same class.
/// Source of truth, hogwarts `live/room/`; ported from Android `class-wire.kt`.
///
/// - `class-channel.ts` — the class channel: JSON `{ "t": … }` on data topic `lc`, reliable.
/// - `use-class-channel.ts` — a raised hand is the participant attributes `hand` ("1" up, "" down)
///   and `handAt` (epoch ms); the host lowers it with `hand.clear` (addressed to the owner) or
///   `hand.clearAll`; `muted` follows a mute-all. Other types (`sync.request`, board, polls…)
///   are ignored.
/// - LiveKit components' `useChat` — chat is a text stream on topic `lk.chat`.
///
/// Host-only messages are trusted only from the class's host or a ROOM-metadata host
/// (`{ "hosts": [...] }`, written server-side) — never from a participant's own attributes,
/// which any student can rewrite.
enum ClassWire {
    static let classTopic = "lc"
    static let chatTopic = "lk.chat"
    static let handAttribute = "hand"
    static let handAtAttribute = "handAt"

    /// `{"t":"<type>"}`
    static func encode(_ type: String) -> Data {
        Data("{\"t\":\"\(type)\"}".utf8)
    }

    /// The message's `t`, or nil for anything that is not a class message.
    static func type(of payload: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: payload) as? [String: Any],
              let t = object["t"] as? String else { return nil }
        return t
    }

    /// `{ "hosts": [...] }` — the room's server-written host list. Garbage → empty.
    static func roomHosts(metadata: String?) -> Set<String> {
        guard let metadata, let data = metadata.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let hosts = object["hosts"] as? [Any] else { return [] }
        return Set(hosts.compactMap { $0 as? String })
    }

    /// Whether a host-only message from `sender` may be obeyed.
    static func isTrustedHost(sender: String?, hostIdentity: String?, roomHosts: Set<String>) -> Bool {
        guard let sender, !sender.isEmpty else { return false }
        return sender == hostIdentity || roomHosts.contains(sender)
    }

    static func handAttributes(up: Bool, nowMs: Int64) -> [String: String] {
        [handAttribute: up ? "1" : "", handAtAttribute: up ? String(nowMs) : ""]
    }

    struct HandInput: Equatable, Sendable {
        var identity: String
        var name: String
        var hand: String?
        var handAt: String?
        var firstSeenMs: Int64
    }

    /// Raised hands in the order they went up: `handAt` first, then when this phone first saw them,
    /// then identity.
    static func handQueue(_ people: [HandInput]) -> [HandInput] {
        func key(_ p: HandInput) -> Int64 { p.handAt.flatMap { Int64($0) } ?? p.firstSeenMs }
        return people.filter { $0.hand == "1" }.sorted {
            let (a, b) = (key($0), key($1))
            return a != b ? a < b : $0.identity < $1.identity
        }
    }
}
