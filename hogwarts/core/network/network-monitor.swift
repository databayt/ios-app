import Foundation
import Network

/// Network connectivity monitor.
///
/// `@MainActor @Observable` so SwiftUI views read `isConnected` directly
/// and Swift 6 strict concurrency stops complaining about cross-actor
/// mutation. The underlying `NWPathMonitor` runs on its own queue and
/// hops back to the main actor via `Task { @MainActor in … }` — no more
/// `DispatchQueue.main.async` and no more `@unchecked Sendable`.
@MainActor
@Observable
final class NetworkMonitor {
    static let shared = NetworkMonitor()

    // `nonisolated`: NWPathMonitor / DispatchQueue are intrinsically
    // thread-safe (the framework synchronizes internally), and the
    // synchronous `isOnline` accessor below needs to read `monitor`
    // without hopping to MainActor.
    private nonisolated let monitor = NWPathMonitor()
    private nonisolated let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    /// Latest observed connectivity. Updated on the main actor only.
    var isConnected: Bool = true

    /// Connection type
    var connectionType: ConnectionType = .unknown

    enum ConnectionType: Sendable {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    /// Synchronous status read from `NWPathMonitor`. Safe to call from any
    /// isolation domain — `NWPath.status` is read-only and thread-safe.
    nonisolated var isOnline: Bool {
        monitor.currentPath.status == .satisfied
    }

    private init() {
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            // `path` is a value type and Sendable; we capture only what we
            // need before hopping to the MainActor to mutate state.
            let connected = path.status == .satisfied
            let type = Self.connectionType(for: path)
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.isConnected = connected
                self.connectionType = type
            }
        }
        monitor.start(queue: monitorQueue)
    }

    private nonisolated static func connectionType(for path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) { return .wifi }
        if path.usesInterfaceType(.cellular) { return .cellular }
        if path.usesInterfaceType(.wiredEthernet) { return .ethernet }
        return .unknown
    }

    deinit {
        monitor.cancel()
    }
}
