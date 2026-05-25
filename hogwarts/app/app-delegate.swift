import UIKit
import UserNotifications
import BackgroundTasks
import GoogleSignIn
import FacebookCore
import os

/// App delegate for push notifications and OAuth URL handling
/// Handles APNs registration, notification delivery, and OAuth callbacks
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    /// CORE-011 — Background-refresh identifier. Must match the entry in
    /// Info.plist's `BGTaskSchedulerPermittedIdentifiers`.
    private static let backgroundRefreshIdentifier = "org.databayt.Hogwarts.refresh"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerNotificationCategories()
        registerForPushNotifications()
        registerBackgroundRefreshTask()

        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    /// CORE-011 — Schedule a fresh sync attempt whenever the app backgrounds.
    /// iOS decides when to actually run it; we just ask for "≥ 15 min from now."
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundRefresh()
    }

    /// PUSH-002 — re-validate APNs registration when the app returns to
    /// foreground. APNs can rotate the device token (rare, but happens on
    /// restore-from-backup); re-registering is cheap and is the only signal
    /// the server gets that a stale token should be replaced.
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.registerForRemoteNotifications()
    }

    // MARK: - URL Handling (OAuth Callbacks)

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        // Google Sign-In
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }

        // Facebook Login
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }

        return false
    }

    // MARK: - Push Notifications

    private func registerForPushNotifications() {
        Task { @MainActor in
            do {
                let granted = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
                guard granted else { return }
                UIApplication.shared.registerForRemoteNotifications()
            } catch {
                Logger.app.error("Notification authorization failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    // MARK: - Background Refresh (CORE-011)

    /// Register the BGAppRefreshTask handler exactly once during launch.
    /// The handler asks SyncEngine to flush, then reschedules itself so
    /// the cadence continues across cold launches.
    private func registerBackgroundRefreshTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.backgroundRefreshIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }
    }

    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        // Reschedule first — if the work crashes, the system has already
        // accepted our next request and won't punish us for the failure.
        scheduleBackgroundRefresh()

        let syncTask = Task {
            await SyncEngine.shared.syncAll()
            task.setTaskCompleted(success: true)
        }

        task.expirationHandler = {
            syncTask.cancel()
            task.setTaskCompleted(success: false)
        }
    }

    private func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundRefreshIdentifier)
        // 15 min is the lowest value iOS honors meaningfully; the system
        // may delay further based on battery + usage patterns.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Logger.app.error("Failed to schedule background refresh: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// PUSH-003 — register notification categories so iOS shows the
    /// expected Quick Actions (Reply, Mark Read, View) directly from
    /// the Lock Screen / banner without launching the app.
    ///
    /// Identifiers MUST match what the backend sets in the APNs payload
    /// `category` field (see `databayt/hogwarts/src/app/api/mobile/notifications/*`).
    private func registerNotificationCategories() {
        // Message: Reply (text input) + Mark Read
        let reply = UNTextInputNotificationAction(
            identifier: "MESSAGE_REPLY",
            title: String(localized: "notif.action.reply"),
            options: [.authenticationRequired],
            textInputButtonTitle: String(localized: "notif.action.send"),
            textInputPlaceholder: String(localized: "notif.action.message_placeholder")
        )
        let markRead = UNNotificationAction(
            identifier: "MESSAGE_MARK_READ",
            title: String(localized: "notif.action.mark_read"),
            options: []
        )
        let messageCategory = UNNotificationCategory(
            identifier: "MESSAGE",
            actions: [reply, markRead],
            intentIdentifiers: [],
            options: []
        )

        // Generic destination categories — tap routes via NotificationRouter.
        let view = UNNotificationAction(
            identifier: "VIEW",
            title: String(localized: "notif.action.view"),
            options: [.foreground]
        )
        let announcementCategory = UNNotificationCategory(
            identifier: "ANNOUNCEMENT",
            actions: [view],
            intentIdentifiers: [],
            options: []
        )
        let attendanceCategory = UNNotificationCategory(
            identifier: "ATTENDANCE",
            actions: [view],
            intentIdentifiers: [],
            options: []
        )
        let gradeCategory = UNNotificationCategory(
            identifier: "GRADE",
            actions: [view],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([
            messageCategory,
            announcementCategory,
            attendanceCategory,
            gradeCategory
        ])
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Task {
            try? await APIClient.shared.registerDeviceToken(token)
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.app.error("Failed to register for notifications: \(error)")
    }

    /// Handle silent push - trigger sync
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        await SyncEngine.shared.syncAll()
        return .newData
    }

    // MARK: - UNUserNotificationCenterDelegate

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .badge, .sound]
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // The notification's userInfo crosses an actor boundary — copy out
        // the two strings we need on the nonisolated side, then hop to
        // MainActor to mutate the router.
        let userInfo = response.notification.request.content.userInfo
        let type = userInfo["type"] as? String
        let id = userInfo["id"] as? String
        guard let type else { return }
        await MainActor.run {
            NotificationNavigationState.shared.handlePushNotification([
                "type": type,
                "id": id as Any
            ])
        }
    }
}

// The old `.didReceiveNotification` NotificationCenter bridge is gone.
// AppDelegate now flips `NotificationNavigationState.shared` directly.
