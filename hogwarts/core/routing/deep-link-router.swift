import Foundation

/// AUTH-014 — Universal Link URL parser + Spotlight identifier parser.
///
/// One router for two activity sources:
///   - `NSUserActivityTypeBrowsingWeb` (Universal Links from Mail/Safari)
///   - `CSSearchableItemActionType` (Spotlight result taps, SRCH-001)
///
/// Both feed `DeepLinkRouter.destination(from:)` which yields a typed
/// `Destination`. The view layer then mutates
/// `NotificationNavigationState.shared` — same singleton that handles
/// push taps, so we get one navigation pipeline for all sources.
enum DeepLinkRouter {

    /// Superset of `NotificationRouter.Destination` — includes auth-only
    /// flows (password reset, magic invite) that pushes never use.
    enum Destination: Hashable {
        case attendance(recordId: String?)
        case grade(resultId: String?)
        case message(conversationId: String?)
        case announcement(id: String?)
        case event(id: String?)
        case fee(invoiceId: String?)
        case dashboard
        // Auth deep-link variants — surface a sheet in LoginView, not a tab.
        case passwordReset(token: String)
        case emailVerification(token: String)
        case inviteAccept(token: String)
    }

    // MARK: - URL parsing (Universal Links + direct opens)

    /// Parse a Universal Link or `hogwarts://` URL into a destination.
    /// Returns nil if the URL is for our host but the path is unknown,
    /// so the caller can decide whether to swallow or fall through.
    static func destination(from url: URL) -> Destination? {
        guard let host = url.host?.lowercased(), Self.allowedHosts.contains(host) else {
            return nil
        }
        let parts = url.pathComponents.filter { $0 != "/" }
        guard let first = parts.first?.lowercased() else { return .dashboard }
        let secondId = parts.count >= 2 ? parts[1] : nil

        switch first {
        case "app":
            // /app/{feature}/{id?}
            return appPath(parts: Array(parts.dropFirst()))
        case "auth":
            // /auth/reset/{token}, /auth/verify/{token}
            guard parts.count >= 3 else { return nil }
            let sub = parts[1].lowercased()
            let token = parts[2]
            if sub == "reset" { return .passwordReset(token: token) }
            if sub == "verify" { return .emailVerification(token: token) }
            return nil
        case "invite":
            guard let token = secondId else { return nil }
            return .inviteAccept(token: token)
        default:
            return nil
        }
    }

    private static func appPath(parts: [String]) -> Destination {
        guard let feature = parts.first?.lowercased() else { return .dashboard }
        let id = parts.count >= 2 ? parts[1] : nil
        switch feature {
        case "messages":      return .message(conversationId: id)
        case "announcements": return .announcement(id: id)
        case "attendance":    return .attendance(recordId: id)
        case "grades":        return .grade(resultId: id)
        case "events":        return .event(id: id)
        case "fees":          return .fee(invoiceId: id)
        default:              return .dashboard
        }
    }

    // MARK: - Spotlight (SRCH-001)

    /// Parse a Core Spotlight item identifier into a destination.
    /// The indexer encodes identifiers as `{type}:{id}` so the inverse
    /// is a single split. Format intentionally matches the userInfo
    /// `type`/`id` keys used by push routing.
    static func destination(fromSpotlightIdentifier identifier: String) -> Destination? {
        let parts = identifier.split(separator: ":", maxSplits: 1).map(String.init)
        guard let type = parts.first?.lowercased() else { return nil }
        let id = parts.count >= 2 ? parts[1] : nil
        switch type {
        case "message":      return .message(conversationId: id)
        case "announcement": return .announcement(id: id)
        case "attendance":   return .attendance(recordId: id)
        case "grade":        return .grade(resultId: id)
        case "event":        return .event(id: id)
        case "fee":          return .fee(invoiceId: id)
        case "contact":      return .message(conversationId: id) // contacts open the conversation
        default:             return nil
        }
    }

    private static let allowedHosts: Set<String> = [
        "ed.databayt.org",
        "www.ed.databayt.org"
    ]
}

// MARK: - Destination bridge

extension DeepLinkRouter.Destination {
    /// Collapse the auth-deep-link variants down to the
    /// `NotificationRouter.Destination` subset so existing routing in
    /// `NotificationNavigationState` keeps working unchanged. Auth
    /// variants (`.passwordReset`, `.emailVerification`, `.inviteAccept`)
    /// are handled separately by the LoginView observer and so return nil.
    var asNotificationDestination: NotificationRouter.Destination? {
        switch self {
        case .attendance(let id):   return .attendance(recordId: id)
        case .grade(let id):        return .grade(resultId: id)
        case .message(let id):      return .message(conversationId: id)
        case .announcement(let id): return .announcement(id: id)
        case .event:                return .announcement(id: nil) // events live in the notifications inbox today
        case .fee:                  return .dashboard              // fees tab gating belongs to dashboard
        case .dashboard:            return .dashboard
        case .passwordReset, .emailVerification, .inviteAccept:
            return nil
        }
    }

    /// Whether this destination is auth-only and should NOT be routed
    /// through the tab navigation. Used by RootView to surface the
    /// matching sheet over LoginView.
    var isAuthFlow: Bool {
        switch self {
        case .passwordReset, .emailVerification, .inviteAccept: return true
        default: return false
        }
    }
}
