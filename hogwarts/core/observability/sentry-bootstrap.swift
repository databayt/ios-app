import Foundation
import Sentry

/// Wraps SentrySDK so the rest of the app talks to a single seam.
/// The init step is a no-op when `SENTRY_DSN` is empty, which is the
/// default in Debug builds — engineers don't want their local crashes
/// to land in the production project, and a real DSN should only be
/// injected via xcconfig in CI/staging/release.
///
/// Mirrors web's Sentry usage (`sentry.databayt` project) and Android's
/// Crashlytics integration — same `<feature>.<action>` event taxonomy
/// per OBS-002.
enum SentryBootstrap {

    /// Call exactly once from `HogwartsApp.init()`.
    /// Honors `OBS.md` cross-cutting rule: NO PII (name, email) leaves the
    /// device. Only `tenant_id`, `role`, `app_locale` are safe.
    static func start() {
        let dsn = Self.dsn
        guard !dsn.isEmpty else { return }

        SentrySDK.start { options in
            options.dsn = dsn
            options.environment = Self.environment
            options.releaseName = Self.releaseName
            options.dist = Self.buildNumber

            // Sample 20% of transactions to keep cost bounded while still
            // having a usable signal for slow screens / network calls.
            options.tracesSampleRate = 0.2
            options.profilesSampleRate = 0.0

            // Screenshots can leak PII (student names on dashboards).
            options.attachScreenshot = false
            options.attachViewHierarchy = false

            // Last line of defense — strip anything that smells like PII
            // before the event leaves the device.
            options.beforeSend = { event in
                event.user?.email = nil
                event.user?.username = nil
                event.user?.ipAddress = nil
                return event
            }
        }
    }

    /// Update the Sentry user scope after a successful login or school
    /// switch. ID is the internal user uuid (not the email). Role and
    /// schoolId are safe to attach; email is explicitly NOT set.
    static func setUserContext(userId: String, schoolId: String?, role: String?, locale: String) {
        let user = User()
        user.userId = userId
        user.data = [
            "tenant_id": schoolId ?? "",
            "role": role ?? "",
            "app_locale": locale
        ]
        SentrySDK.setUser(user)
    }

    /// Clear the Sentry user scope on logout.
    static func clearUserContext() {
        SentrySDK.setUser(nil)
    }

    // MARK: - Config

    private static var dsn: String {
        (Bundle.main.object(forInfoDictionaryKey: "SENTRY_DSN") as? String) ?? ""
    }

    private static var environment: String {
        let raw = (Bundle.main.object(forInfoDictionaryKey: "SENTRY_ENVIRONMENT") as? String) ?? ""
        return raw.isEmpty ? "debug" : raw.lowercased()
    }

    private static var releaseName: String {
        let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "0.0.0"
        return "hogwarts-ios@\(version)"
    }

    private static var buildNumber: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0"
    }
}
