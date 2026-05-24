import SwiftUI

// MARK: - DTO
//
// Mirrors `/api/mobile/exams/:id/certificate`. Returns once the school has
// issued a certificate for the student's completed exam.

struct ExamCertificate: Codable, Sendable, Identifiable {
    var id: String { certificateId }
    let certificateId: String
    let certificateNumber: String?
    let examTitle: String
    let studentName: String
    let studentNameAr: String?
    let score: Double?
    let grade: String?
    let rank: Int?
    let issuedAt: Date
    let expiresAt: Date?
    let certificateUrl: String?
    let thumbnailUrl: String?
    let verificationCode: String?
    let verificationUrl: String?
    let certificateType: String?
    let status: String?

    /// Display name in the active locale's preferred language. Falls back
    /// to canonical when no Arabic variant is present.
    func displayName(for locale: Locale) -> String {
        let isArabic = (locale.language.languageCode?.identifier ?? "ar") == "ar"
        if isArabic, let ar = studentNameAr, !ar.isEmpty { return ar }
        return studentName
    }
}
