import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/notifications/preferences` GET (data + defaults
// when no rows stored) and PUT (`{preferences: [{type, channel, enabled}]}`).
//
// The backend lets each (type, channel) pair toggle independently — the
// UI groups by type so users see one row per category with a switch per
// channel.

struct NotificationPreferenceRow: Codable, Identifiable, Hashable, Sendable {
    let id: String?
    let type: String
    let channel: String
    let enabled: Bool
    let quietHoursStart: Int?
    let quietHoursEnd: Int?
    let digestEnabled: Bool?
    let digestFrequency: String?
}

struct NotificationPreferenceDefaults: Codable, Sendable {
    let inApp: Bool?
    let email: Bool?
    let push: Bool?
    let sms: Bool?
    let quietHoursStart: Int?
    let quietHoursEnd: Int?
}

struct NotificationPreferencesResponse: Codable, Sendable {
    let data: [NotificationPreferenceRow]
    let defaults: NotificationPreferenceDefaults?
}

struct NotificationPreferenceUpdate: Codable, Sendable {
    let type: String
    let channel: String
    let enabled: Bool
}

struct NotificationPreferencesUpdateBody: Codable, Sendable {
    let preferences: [NotificationPreferenceUpdate]
}

// MARK: - Domain enums

enum NotificationCategory: String, CaseIterable, Sendable, Hashable {
    case message
    case attendance
    case grade
    case exam
    case fee
    case announcement
    case event
    case system

    var label: LocalizedStringResource {
        switch self {
        case .message:      "notifPrefs.cat.message"
        case .attendance:   "notifPrefs.cat.attendance"
        case .grade:        "notifPrefs.cat.grade"
        case .exam:         "notifPrefs.cat.exam"
        case .fee:          "notifPrefs.cat.fee"
        case .announcement: "notifPrefs.cat.announcement"
        case .event:        "notifPrefs.cat.event"
        case .system:       "notifPrefs.cat.system"
        }
    }

    var systemImage: String {
        switch self {
        case .message:      "bubble.left.and.bubble.right"
        case .attendance:   "checkmark.circle"
        case .grade:        "chart.bar"
        case .exam:         "graduationcap"
        case .fee:          "dollarsign.circle"
        case .announcement: "megaphone"
        case .event:        "star"
        case .system:       "gear"
        }
    }

    var color: Color {
        switch self {
        case .message:      .accentBlue
        case .attendance:   .accentGreen
        case .grade:        .accentPurple
        case .exam:         .accentRed
        case .fee:          .accentOrange
        case .announcement: .accentRed
        case .event:        .accentPink
        case .system:       .appleGray1
        }
    }
}

enum NotificationChannel: String, CaseIterable, Sendable, Hashable {
    case push
    case email
    case sms
    case inApp = "in_app"

    var label: LocalizedStringResource {
        switch self {
        case .push:  "notifPrefs.channel.push"
        case .email: "notifPrefs.channel.email"
        case .sms:   "notifPrefs.channel.sms"
        case .inApp: "notifPrefs.channel.inApp"
        }
    }

    var systemImage: String {
        switch self {
        case .push:  "bell.fill"
        case .email: "envelope.fill"
        case .sms:   "message.fill"
        case .inApp: "app.badge.fill"
        }
    }
}
