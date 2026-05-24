import SwiftUI

// MARK: - DTOs
//
// Mirrors web `/api/mobile/subjects` (list), `/api/mobile/subjects/:id`
// (detail) and `/api/mobile/subjects/my-subjects`. The list and detail
// responses share base fields; detail adds banner, curriculum metadata
// and a chapters → lessons tree.
//
// All snake_case fields are folded to camelCase by APIClient. The web
// also accepts `?lang=` and returns localized strings — the actions layer
// passes the active `Locale` so display text is already translated when
// it lands here.

struct CatalogSubjectListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let slug: String?
    let department: String?
    let description: String?
    let thumbnailUrl: String?
    let color: String?
    let levels: [String]?
    let grades: [String]?
    let totalChapters: Int?
    let totalLessons: Int?
    let averageRating: Double?
    let ratingCount: Int?

    /// Pre-computed display chip used by both list and detail.
    var levelBadge: String? {
        levels?.first?.capitalized
    }

    var gradeBadge: String? {
        guard let grades, !grades.isEmpty else { return nil }
        if grades.count == 1 { return "G\(grades[0])" }
        return "G\(grades.first ?? "")–\(grades.last ?? "")"
    }
}

struct CatalogSubjectsListResponse: Codable, Sendable {
    let data: [CatalogSubjectListItem]
    let total: Int
}

struct MySubjectsListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let slug: String?
    let department: String?
    let thumbnailUrl: String?
}

struct MySubjectsResponse: Codable, Sendable {
    let data: [MySubjectsListItem]
}

struct CatalogSubjectDetail: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let slug: String?
    let description: String?
    let department: String?
    let color: String?
    let thumbnailUrl: String?
    let bannerUrl: String?
    let levels: [String]?
    let grades: [String]?
    let gradeRange: String?
    let curriculum: String?
    let country: String?
    let tags: [String]?
    let totalChapters: Int?
    let totalLessons: Int?
    let totalContent: Int?
    let usageCount: Int?
    let averageRating: Double?
    let ratingCount: Int?
    let status: String?
    let chapters: [CatalogChapter]?
}

struct CatalogChapter: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let slug: String?
    let description: String?
    let color: String?
    let thumbnail: String?
    let totalLessons: Int?
    let lessons: [CatalogLesson]?
}

struct CatalogLesson: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let slug: String?
    let description: String?
    let color: String?
    let thumbnail: String?
    let durationMinutes: Int?
    let videoCount: Int?
    let resourceCount: Int?

    /// Human-readable duration ("5 min", "1 h 12 min").
    var formattedDuration: String? {
        guard let durationMinutes, durationMinutes > 0 else { return nil }
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(durationMinutes) min"
    }
}

// MARK: - Color helper
//
// Backend stores `color` as a hex string (`"#3B82F6"`). When present we
// honor it; otherwise we fall back to a deterministic derivation from the
// subject `name` so the catalog grid never looks visually empty even when
// the catalog hasn't picked a brand color.

extension Color {
    /// Parse a hex string ("#RRGGBB" or "RRGGBB") into a SwiftUI `Color`.
    /// Returns nil for malformed input so callers can fall back gracefully.
    init?(hex: String?) {
        guard let raw = hex?.trimmingCharacters(in: .whitespaces) else { return nil }
        let normalized = raw.hasPrefix("#") ? String(raw.dropFirst()) : raw
        guard normalized.count == 6,
              let value = UInt64(normalized, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    /// Stable color derived from a string. Two strings with the same value
    /// always produce the same color — useful for placeholder thumbnails.
    static func deterministic(from seed: String) -> Color {
        let palette: [Color] = [
            .accentBlue, .accentGreen, .accentOrange, .accentPurple,
            .accentRed, .accentTeal, .accentIndigo, .accentPink, .accentYellow,
        ]
        let hash = abs(seed.hashValue)
        return palette[hash % palette.count]
    }
}
