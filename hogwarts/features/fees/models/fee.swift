import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/fees` (list) and `/api/mobile/fees/summary/:studentId`
// (totals card). Backend amounts arrive as JSON numbers (Prisma Decimal →
// Number), so we model them as `Double` here.

struct FeeRecord: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let feeType: String?
    let amount: Double
    let paidAmount: Double
    let dueDate: Date?
    let paymentDate: Date?
    let paymentMethod: String?
    let status: String?
    let lateFee: Double?
    let discount: Double?
    let receiptNumber: String?
    let remarks: String?

    /// Outstanding balance after partial payments.
    var outstanding: Double {
        max(0, amount + (lateFee ?? 0) - (discount ?? 0) - paidAmount)
    }

    var statusKind: FeeStatus { FeeStatus(raw: status) }

    /// Day count until/since due date — negative when overdue.
    func daysUntilDue(now: Date = .now, calendar: Calendar = .current) -> Int? {
        guard let dueDate else { return nil }
        let start = calendar.startOfDay(for: now)
        let due = calendar.startOfDay(for: dueDate)
        return calendar.dateComponents([.day], from: start, to: due).day
    }
}

struct FeeListResponse: Codable, Sendable {
    let data: [FeeRecord]
    let total: Int
    let page: Int
    let perPage: Int
}

struct FeeSummary: Codable, Sendable {
    let totalAmount: Double
    let totalPaid: Double
    let totalPending: Double
    let totalRecords: Int
    let overdueCount: Int
    let paidCount: Int
    let pendingCount: Int

    /// Paid percentage 0…1 — used by the progress bar in the summary card.
    var paidProgress: Double {
        guard totalAmount > 0 else { return 0 }
        return min(1.0, totalPaid / totalAmount)
    }
}

// MARK: - Domain enums

enum FeeStatus: String, CaseIterable, Sendable, Hashable {
    case paid
    case pending
    case partial
    case overdue
    case waived
    case unknown

    init(raw: String?) {
        switch raw?.uppercased() {
        case "PAID":    self = .paid
        case "PENDING": self = .pending
        case "PARTIAL": self = .partial
        case "OVERDUE": self = .overdue
        case "WAIVED":  self = .waived
        default:        self = .unknown
        }
    }

    var color: Color {
        switch self {
        case .paid:    .accentGreen
        case .pending: .accentOrange
        case .partial: .accentYellow
        case .overdue: .accentRed
        case .waived:  .appleGray1
        case .unknown: .appleGray1
        }
    }

    var systemImage: String {
        switch self {
        case .paid:    "checkmark.seal.fill"
        case .pending: "clock"
        case .partial: "circle.lefthalf.filled"
        case .overdue: "exclamationmark.triangle.fill"
        case .waived:  "minus.circle"
        case .unknown: "questionmark.circle"
        }
    }

    var label: LocalizedStringResource {
        switch self {
        case .paid:    "fees.status.paid"
        case .pending: "fees.status.pending"
        case .partial: "fees.status.partial"
        case .overdue: "fees.status.overdue"
        case .waived:  "fees.status.waived"
        case .unknown: "fees.status.unknown"
        }
    }
}

// MARK: - Currency formatting helper

extension Double {
    /// Format a fee amount using the active locale + tenant currency.
    /// Pass `currencyCode: tenantContext.school?.currency ?? "SAR"` from
    /// the call site once `/mobile/admin/school` has populated the
    /// extended School fields; SAR remains the safe pilot default.
    func formattedAsCurrency(locale: Locale, currencyCode: String = "SAR") -> String {
        formatted(.currency(code: currencyCode).locale(locale))
    }

    /// Convenience overload reading the active tenant's currency.
    /// Equivalent to `formattedAsCurrency(locale:currencyCode:)` but
    /// keeps fees views from having to repeat the nil-coalesce.
    func formattedAsCurrency(locale: Locale, tenant: TenantContext) -> String {
        formattedAsCurrency(locale: locale, currencyCode: tenant.school?.currency ?? "SAR")
    }
}
