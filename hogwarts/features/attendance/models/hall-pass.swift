import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/attendance/hall-pass`. The list view shows passes
// the user can see (their own as a student; class passes as a teacher);
// the detail view supports return-marking later.

struct HallPass: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let studentId: String
    let studentName: String?
    let classId: String?
    let destination: String?
    let destinationNote: String?
    let issuedBy: String?
    let issuedAt: Date
    let expectedDuration: Int?
    let expectedReturn: Date
    let returnedAt: Date?
    let status: String

    var statusKind: HallPassStatus { HallPassStatus(raw: status) }

    /// Computed remaining minutes vs `expectedReturn`. Negative = overdue.
    func minutesRemaining(now: Date = .now) -> Int {
        Int(expectedReturn.timeIntervalSince(now) / 60.0)
    }
}

struct HallPassListResponse: Codable, Sendable {
    let data: [HallPass]
}

enum HallPassStatus: String, CaseIterable, Sendable, Hashable {
    case active
    case returned
    case overdue
    case cancelled
    case unknown

    init(raw: String) {
        switch raw.uppercased() {
        case "ACTIVE":    self = .active
        case "RETURNED":  self = .returned
        case "OVERDUE":   self = .overdue
        case "CANCELLED": self = .cancelled
        default:          self = .unknown
        }
    }

    var color: Color {
        switch self {
        case .active:    .accentBlue
        case .returned:  .accentGreen
        case .overdue:   .accentRed
        case .cancelled: .appleGray1
        case .unknown:   .appleGray1
        }
    }

    var systemImage: String {
        switch self {
        case .active:    "figure.walk.motion"
        case .returned:  "checkmark.seal.fill"
        case .overdue:   "exclamationmark.triangle.fill"
        case .cancelled: "xmark.circle"
        case .unknown:   "questionmark.circle"
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .active:    "hallPass.status.active"
        case .returned:  "hallPass.status.returned"
        case .overdue:   "hallPass.status.overdue"
        case .cancelled: "hallPass.status.cancelled"
        case .unknown:   "hallPass.status.unknown"
        }
    }
}
