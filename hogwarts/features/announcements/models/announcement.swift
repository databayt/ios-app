import SwiftUI

// MARK: - DTOs
//
// Mirrors web `/api/mobile/announcements` route. APIClient already applies
// `.convertFromSnakeCase`, so Swift fields stay camelCase and `published_at`
// → `publishedAt` automatically.
//
// The list endpoint returns a thinner shape than the detail endpoint —
// the two structs share the common fields and the detail adds metadata
// (scope, pinned, featured, target class/role, read count).

struct AnnouncementListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let content: String
    let priority: String?
    let publishedAt: Date?
    let expiresAt: Date?
    let authorName: String?
    let authorAvatar: String?

    var priorityKind: AnnouncementPriority {
        AnnouncementPriority(raw: priority)
    }

    /// True when the announcement was published in the last 48 hours — used
    /// to group items into the "Recent" section.
    var isRecent: Bool {
        guard let publishedAt else { return false }
        return publishedAt > Date(timeIntervalSinceNow: -48 * 3600)
    }
}

struct AnnouncementsListResponse: Codable, Sendable {
    let data: [AnnouncementListItem]
    let total: Int
    let page: Int
    let perPage: Int
}

struct AnnouncementDetail: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let content: String
    let scope: String?
    let priority: String?
    let isPublished: Bool
    let publishedAt: Date?
    let expiresAt: Date?
    let isPinned: Bool
    let isFeatured: Bool
    let targetClass: TargetClass?
    let targetRole: String?
    let readCount: Int
    let createdAt: Date
    let authorName: String?
    let authorAvatar: String?

    struct TargetClass: Codable, Sendable {
        let id: String
        let name: String
    }

    var priorityKind: AnnouncementPriority {
        AnnouncementPriority(raw: priority)
    }
}

// MARK: - Domain enums

/// Priority bucket used by both list and detail surfaces. Maps the free-form
/// string from the backend (`HIGH`/`MEDIUM`/`LOW`/`NORMAL`/null) to a stable
/// enum the UI can color-code without duplicating the switch logic.
enum AnnouncementPriority: String, CaseIterable, Sendable {
    case high
    case medium
    case low
    case unknown

    init(raw: String?) {
        switch raw?.lowercased() {
        case "high", "urgent": self = .high
        case "medium", "normal": self = .medium
        case "low": self = .low
        default: self = .unknown
        }
    }

    var color: Color {
        switch self {
        case .high: .accentRed
        case .medium: .accentOrange
        case .low: .accentBlue
        case .unknown: .appleGray1
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .high: "announcements.priority.high"
        case .medium: "announcements.priority.medium"
        case .low: "announcements.priority.low"
        case .unknown: "announcements.priority.unknown"
        }
    }

    var systemImage: String {
        switch self {
        case .high: "exclamationmark.triangle.fill"
        case .medium: "info.circle.fill"
        case .low: "circle.fill"
        case .unknown: "circle"
        }
    }
}
