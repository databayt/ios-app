import UIKit
import UserNotifications
import GoogleSignIn
import FacebookCore
import os

/// App delegate for push notifications and OAuth URL handling
/// Handles APNs registration, notification delivery, and OAuth callbacks
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()

        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
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
