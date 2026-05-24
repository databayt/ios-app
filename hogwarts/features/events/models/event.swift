import SwiftUI

// MARK: - DTOs
//
// Mirrors web `/api/mobile/events` (list) and `/api/mobile/events/:id`
// (detail). Backend keys are snake_case; APIClient already applies
// `.convertFromSnakeCase`, so Swift fields are camelCase.

struct SchoolEventListItem: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let description: String?
    let startDate: Date?
    let startTime: String?
    let endTime: String?
    let location: String?
    let type: String?
    let isPublic: Bool?
    let organizerName: String?
    let status: String?

    var kind: SchoolEventKind { SchoolEventKind(raw: type) }

    /// True when the event is in the future (or today) — used to bucket the
    /// list into Upcoming vs Past sections.
    var isUpcoming: Bool {
        guard let startDate else { return false }
        return startDate >= Calendar.current.startOfDay(for: .now)
    }
}

struct SchoolEventDetail: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let description: String?
    let startDate: Date?
    let startTime: String?
    let endTime: String?
    let location: String?
    let type: String?
    let isPublic: Bool?
    let registrationRequired: Bool?
    let maxAttendees: Int?
    let currentAttendees: Int?
    let registrationCount: Int?
    let organizerName: String?
    let targetAudience: String?
    let notes: String?
    let status: String?
    let createdAt: Date?
    let isRegistered: Bool?
    let registrationStatus: String?

    var kind: SchoolEventKind { SchoolEventKind(raw: type) }

    /// Combine `startDate` (which holds calendar day from the backend) with
    /// the `startTime`/`endTime` strings (HH:mm) to produce the actual
    /// instants we hand to EventKit.
    func resolvedRange(in calendar: Calendar = .current) -> (start: Date, end: Date)? {
        guard let startDate else { return nil }
        let start = combine(date: startDate, time: startTime, calendar: calendar) ?? startDate
        let end = combine(date: startDate, time: endTime, calendar: calendar)
            ?? start.addingTimeInterval(60 * 60)
        return (start, end)
    }

    private func combine(date: Date, time: String?, calendar: Calendar) -> Date? {
        guard let time, let parsed = SchoolEventDetail.timeParser(time) else { return nil }
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = parsed.hour
        components.minute = parsed.minute
        return calendar.date(from: components)
    }

    /// Parses "HH:mm" or "h:mm a" into hour + minute. Returns nil for the
    /// junk inputs the backend occasionally emits ("TBA", null-ish).
    static func timeParser(_ raw: String) -> (hour: Int, minute: Int)? {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        let parts = trimmed.split(separator: ":")
        if parts.count >= 2,
           let h = Int(parts[0]),
           let m = Int(parts[1].prefix(2)) {
            // "h:mm a" — handle " AM"/" PM" suffix.
            let suffix = parts[1].dropFirst(2).trimmingCharacters(in: .whitespaces).uppercased()
            var hour = h
            if suffix == "PM", h < 12 { hour += 12 }
            if suffix == "AM", h == 12 { hour = 0 }
            return (hour, m)
        }
        return nil
    }
}

struct SchoolEventsListResponse: Codable, Sendable {
    let data: [SchoolEventListItem]
    let total: Int
    let page: Int
    let perPage: Int
}

// MARK: - Domain enums

enum SchoolEventKind: String, CaseIterable, Sendable {
    case academic
    case sports
    case cultural
    case meeting
    case holiday
    case other

    init(raw: String?) {
        switch raw?.lowercased() {
        case "academic", "exam", "lesson": self = .academic
        case "sports", "sport":             self = .sports
        case "cultural", "art":             self = .cultural
        case "meeting":                     self = .meeting
        case "holiday", "vacation":         self = .holiday
        default:                            self = .other
        }
    }

    var color: Color {
        switch self {
        case .academic: .accentBlue
        case .sports:   .accentGreen
        case .cultural: .accentPurple
        case .meeting:  .accentOrange
        case .holiday:  .accentPink
        case .other:    .appleGray1
        }
    }

    var systemImage: String {
        switch self {
        case .academic: "book.fill"
        case .sports:   "sportscourt.fill"
        case .cultural: "music.note"
        case .meeting:  "person.3.fill"
        case .holiday:  "sun.max.fill"
        case .other:    "calendar"
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .academic: "events.kind.academic"
        case .sports:   "events.kind.sports"
        case .cultural: "events.kind.cultural"
        case .meeting:  "events.kind.meeting"
        case .holiday:  "events.kind.holiday"
        case .other:    "events.kind.other"
        }
    }
}
