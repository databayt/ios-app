import Foundation
import Observation

/// `/live/[id]` — one class's page. Mirrors Android `live-session-view-model.kt`.
@MainActor
@Observable
final class LiveSessionViewModel {
    let sessionId: String
    private(set) var page: SessionPage?
    private(set) var isLoading = false
    private(set) var error: String?

    @ObservationIgnored private let actions: LiveActions

    init(sessionId: String, actions: LiveActions = LiveActions()) {
        self.sessionId = sessionId
        self.actions = actions
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            page = try await actions.session(id: sessionId)
            error = nil
        } catch {
            if page == nil { self.error = error.localizedDescription }
        }
    }
}
