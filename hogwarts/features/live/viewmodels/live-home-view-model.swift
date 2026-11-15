import Foundation
import Observation

/// `/live` landing: what is on now, what is next. Mirrors Android `live-home-view-model.kt`.
@MainActor
@Observable
final class LiveHomeViewModel {
    private(set) var landing: LiveLandingResponse?
    private(set) var isLoading = false
    private(set) var error: String?

    @ObservationIgnored private let actions: LiveActions

    init(actions: LiveActions = LiveActions()) {
        self.actions = actions
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            landing = try await actions.landing()
            error = nil
        } catch {
            // Keep stale data on a failed refresh; only say so when there is nothing to show.
            if landing == nil { self.error = error.localizedDescription }
        }
    }
}
