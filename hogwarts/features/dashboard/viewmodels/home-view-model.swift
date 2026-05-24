import Foundation
import SwiftUI

// MARK: - HomeViewModel
//
// Drives the iOS-style 4×4 home grid. Fetches the unified `/mobile/dashboard`
// payload (already in use by the role-specific dashboards) and projects it
// down to `HomeTileBadgeCounts` so tile badges render against real numbers.
//
// Mirrors `DashboardViewModel.uiState.pendingAttendance / upcomingExams / ...`
// from `kotlin-app/feature/dashboard/.../dashboard-view-model.kt`.

@MainActor
@Observable
final class HomeViewModel {
    /// Current badge counts shown on the home grid.
    private(set) var counts: HomeTileBadgeCounts = .zero
    private(set) var isLoading = false
    private(set) var lastError: String?
    /// Greeting subtitle ("Good morning, Ahmed") used by the future home header.
    private(set) var greetingName: String?

    private let actions = DashboardActions()

    /// Fetch the dashboard payload and project it to `HomeTileBadgeCounts`.
    /// Safe to call on every screen appearance — re-renders only when values
    /// actually change because `HomeTileBadgeCounts: Equatable`.
    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let response = try await actions.fetchDashboard()
            counts = Self.project(response: response, previous: counts)
            greetingName = response.userName
        } catch is CancellationError {
            // Task cancelled (view disappeared) — leave previous values intact.
        } catch {
            lastError = error.localizedDescription
            // Preserve last good counts; degraded UX > empty UX.
        }
    }

    /// Map the wire payload to the homegrid badge model. Counts the API does
    /// not yet expose (per-role endpoints) are preserved from `previous` so
    /// tiles don't flash to zero while role-specific fetches are pending.
    static func project(
        response: DashboardResponse,
        previous: HomeTileBadgeCounts
    ) -> HomeTileBadgeCounts {
        HomeTileBadgeCounts(
            pendingAttendance: previous.pendingAttendance,
            upcomingExams: previous.upcomingExams,
            todayClasses: previous.todayClasses,
            unreadMessages: previous.unreadMessages,
            unreadNotifications: response.unreadNotifications ?? previous.unreadNotifications,
            pendingAssignments: previous.pendingAssignments
        )
    }
}
