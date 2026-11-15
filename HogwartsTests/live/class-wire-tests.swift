import Foundation
import Testing
@testable import Hogwarts

/// Locks the class-channel wire that the phone shares with the web room and Android.
@Suite("ClassWire")
struct ClassWireTests {

    // MARK: - Encoding / typing

    @Test("encode produces the web's {\"t\":…} payload")
    func encodes() {
        #expect(String(data: ClassWire.encode("hand.clearAll"), encoding: .utf8) == #"{"t":"hand.clearAll"}"#)
        #expect(String(data: ClassWire.encode("muted"), encoding: .utf8) == #"{"t":"muted"}"#)
    }

    @Test("type(of:) reads t and ignores everything else")
    func decodesType() {
        #expect(ClassWire.type(of: Data(#"{"t":"hand.clear"}"#.utf8)) == "hand.clear")
        #expect(ClassWire.type(of: Data(#"{"t":"wb.stroke","stroke":{"id":"x"}}"#.utf8)) == "wb.stroke")
        #expect(ClassWire.type(of: Data(#"{"x":1}"#.utf8)) == nil)
        #expect(ClassWire.type(of: Data(#"{"t":5}"#.utf8)) == nil)
        #expect(ClassWire.type(of: Data("not json".utf8)) == nil)
        #expect(ClassWire.type(of: Data("[]".utf8)) == nil)
        #expect(ClassWire.type(of: Data()) == nil)
    }

    // MARK: - Hands

    @Test("hand attributes: up carries a timestamp, down clears both")
    func handAttributes() {
        #expect(ClassWire.handAttributes(up: true, nowMs: 1_700_000_000_123) == ["hand": "1", "handAt": "1700000000123"])
        #expect(ClassWire.handAttributes(up: false, nowMs: 99) == ["hand": "", "handAt": ""])
    }

    @Test("hand queue is ordered by handAt, then first-seen, then identity")
    func handQueueOrdering() {
        let queue = ClassWire.handQueue([
            .init(identity: "c", name: "C", hand: "1", handAt: "300", firstSeenMs: 1),
            .init(identity: "a", name: "A", hand: "1", handAt: "100", firstSeenMs: 9),
            .init(identity: "down", name: "D", hand: "", handAt: "50", firstSeenMs: 0),
            .init(identity: "none", name: "N", hand: nil, handAt: nil, firstSeenMs: 0),
            // No handAt: falls back to when this phone first saw it (200 → between a and c).
            .init(identity: "b", name: "B", hand: "1", handAt: nil, firstSeenMs: 200),
            // Same key as "b": identity breaks the tie.
            .init(identity: "a2", name: "A2", hand: "1", handAt: "200", firstSeenMs: 0),
            // Garbage handAt behaves like a missing one.
            .init(identity: "z", name: "Z", hand: "1", handAt: "soon", firstSeenMs: 400),
        ])
        #expect(queue.map(\.identity) == ["a", "a2", "b", "c", "z"])
    }

    @Test("empty input gives an empty queue")
    func handQueueEmpty() {
        #expect(ClassWire.handQueue([]).isEmpty)
    }

    // MARK: - Host trust

    @Test("room metadata hosts parse; garbage is empty")
    func roomHosts() {
        #expect(ClassWire.roomHosts(metadata: #"{"hosts":["teacher-1","co-2"]}"#) == ["teacher-1", "co-2"])
        #expect(ClassWire.roomHosts(metadata: #"{"hosts":[]}"#).isEmpty)
        #expect(ClassWire.roomHosts(metadata: #"{"hosts":["a",3,null,"b"]}"#) == ["a", "b"])
        #expect(ClassWire.roomHosts(metadata: #"{"other":1}"#).isEmpty)
        #expect(ClassWire.roomHosts(metadata: #"{"hosts":"teacher"}"#).isEmpty)
        #expect(ClassWire.roomHosts(metadata: "garbage{").isEmpty)
        #expect(ClassWire.roomHosts(metadata: "").isEmpty)
        #expect(ClassWire.roomHosts(metadata: nil).isEmpty)
    }

    @Test("host trust: the class host and metadata hosts pass, strangers do not")
    func hostTrust() {
        let hosts: Set<String> = ["co-2"]
        #expect(ClassWire.isTrustedHost(sender: "teacher-1", hostIdentity: "teacher-1", roomHosts: hosts))
        #expect(ClassWire.isTrustedHost(sender: "co-2", hostIdentity: "teacher-1", roomHosts: hosts))
        #expect(!ClassWire.isTrustedHost(sender: "student-9", hostIdentity: "teacher-1", roomHosts: hosts))
        #expect(!ClassWire.isTrustedHost(sender: nil, hostIdentity: "teacher-1", roomHosts: hosts))
        #expect(!ClassWire.isTrustedHost(sender: "", hostIdentity: "", roomHosts: []))
        #expect(!ClassWire.isTrustedHost(sender: "teacher-1", hostIdentity: nil, roomHosts: []))
    }

    @Test("topics match the web")
    func topics() {
        #expect(ClassWire.classTopic == "lc")
        #expect(ClassWire.chatTopic == "lk.chat")
    }
}
