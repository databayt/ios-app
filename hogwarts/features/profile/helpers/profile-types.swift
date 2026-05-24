import Foundation

/// Type definitions for Profile feature
/// Mirrors: src/components/platform/profile/types.ts

// MARK: - Theme

/// App appearance theme
enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark

    var displayName: String {
        switch self {
        case .system: return String(localized: "profile.theme.system")
        case .light: return String(localized: "profile.theme.light")
        case .dark: return String(localized: "profile.theme.dark")
        }
    }

    var icon: String {
        switch self {
        case .system: return "gear"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }
}

// MARK: - Profile Request

/// Update profile request
/// Web API: PUT /mobile/profile — body: {username?, bio?}
struct ProfileUpdateRequest: Encodable {
    let username: String?
    let bio: String?
}

/// Legacy update profile request (kept for reference — not used by web API)
struct UpdateProfileRequest: Encodable {
    let name: String?
    let nameAr: String?
    let phone: String?
    let imageUrl: String?
}

// MARK: - Notification Preferences

/// Per-type notification toggles
struct NotificationPreferences: Codable {
    var attendance: Bool
    var grade: Bool
    var message: Bool
    var announcement: Bool
    var system: Bool

    static let `default` = NotificationPreferences(
        attendance: true,
        grade: true,
        message: true,
        announcement: true,
        system: true
    )
}

// NotificationType is defined in notifications-types.swift
// Reuse it from there for notification preferences
