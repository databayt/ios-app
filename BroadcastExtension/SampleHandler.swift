import LiveKit

#if os(iOS)
/// ReplayKit broadcast upload extension: LiveKit's `LKSampleHandler` forwards the
/// system screen capture to the app (shared app group) which publishes it to the room.
@available(macCatalyst 13.1, *)
class SampleHandler: LKSampleHandler {
    override var enableLogging: Bool { true }
}
#endif
