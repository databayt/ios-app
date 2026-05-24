import AppIntents
import SwiftUI

/// iOS 18 `AppShortcut` registrations — exposes deep links into the app
/// via Siri, Spotlight, and the long-press menu on the app icon.
///
/// Each intent is a thin wrapper that flips
/// `NotificationNavigationState.shared.selectedTab`. The app is
/// backgrounded when the intent fires from outside, so a `perform()` that
/// returns `.result()` is enough — the launch hand-off does the rest.
@available(iOS 18, *)
struct HogwartsAppShortcuts: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenDashboardIntent(),
            phrases: [
                "Open \(.applicationName) dashboard",
                "Show me \(.applicationName)"
            ],
            shortTitle: "Dashboard",
            systemImageName: "house"
        )
        AppShortcut(
            intent: OpenScheduleIntent(),
            phrases: [
                "Show my \(.applicationName) schedule",
                "What's next in \(.applicationName)"
            ],
            shortTitle: "Today's Schedule",
            systemImageName: "calendar"
        )
        AppShortcut(
            intent: OpenMessagesIntent(),
            phrases: [
                "Open \(.applicationName) messages",
                "Show \(.applicationName) chats"
            ],
            shortTitle: "Messages",
            systemImageName: "bubble.left.and.bubble.right"
        )
        AppShortcut(
            intent: MarkAttendanceIntent(),
            phrases: [
                "Mark attendance in \(.applicationName)"
            ],
            shortTitle: "Mark Attendance",
            systemImageName: "checkmark.circle"
        )
    }
}

// MARK: - Intents

@available(iOS 18, *)
struct OpenDashboardIntent: AppIntent {
    static let title: LocalizedStringResource = "Open Dashboard"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationNavigationState.shared.selectedTab = .dashboard
        return .result()
    }
}

@available(iOS 18, *)
struct OpenScheduleIntent: AppIntent {
    static let title: LocalizedStringResource = "Today's Schedule"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationNavigationState.shared.selectedTab = .schedule
        return .result()
    }
}

@available(iOS 18, *)
struct OpenMessagesIntent: AppIntent {
    static let title: LocalizedStringResource = "Messages"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationNavigationState.shared.selectedTab = .messages
        return .result()
    }
}

/// Opens the dashboard where attendance marking lives — a Phase-2
/// enhancement can deep-link directly into the marking sheet once the
/// teacher's current class is inferred from timetable state.
@available(iOS 18, *)
struct MarkAttendanceIntent: AppIntent {
    static let title: LocalizedStringResource = "Mark Attendance"
    static let openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationNavigationState.shared.selectedTab = .dashboard
        NotificationNavigationState.shared.pendingDestination = .attendance(recordId: nil)
        return .result()
    }
}
