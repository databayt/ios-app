import Foundation
import Testing
@testable import Hogwarts

@Suite("ExamCertificate.displayName(for:)")
struct ExamCertificateDisplayNameTests {

    @Test("Arabic locale prefers studentNameAr")
    func arabicPrefersAr() {
        let cert = make(name: "John Doe", nameAr: "جون دو")
        #expect(cert.displayName(for: Locale(identifier: "ar")) == "جون دو")
    }

    @Test("English locale uses canonical name")
    func englishUsesCanonical() {
        let cert = make(name: "John Doe", nameAr: "جون دو")
        #expect(cert.displayName(for: Locale(identifier: "en")) == "John Doe")
    }

    @Test("Arabic locale falls back to canonical when Arabic missing")
    func arabicFallback() {
        let cert = make(name: "John Doe", nameAr: nil)
        #expect(cert.displayName(for: Locale(identifier: "ar")) == "John Doe")

        let blank = make(name: "John Doe", nameAr: "")
        #expect(blank.displayName(for: Locale(identifier: "ar")) == "John Doe")
    }

    private func make(name: String, nameAr: String?) -> ExamCertificate {
        ExamCertificate(
            certificateId: "c1",
            certificateNumber: nil,
            examTitle: "Math Final",
            studentName: name,
            studentNameAr: nameAr,
            score: nil, grade: nil, rank: nil,
            issuedAt: Date(),
            expiresAt: nil, certificateUrl: nil, thumbnailUrl: nil,
            verificationCode: nil, verificationUrl: nil,
            certificateType: nil, status: nil
        )
    }
}

@Suite("SchoolExamType")
struct SchoolExamTypeTests {

    @Test("Maps backend exam types", arguments: [
        ("quiz", SchoolExamType.quiz),
        ("midterm", .midterm),
        ("final", .final),
        ("mock", .mock),
        ("practice", .practice),
    ])
    func mapsCanonical(raw: String, expected: SchoolExamType) {
        #expect(SchoolExamType(raw: raw) == expected)
    }

    @Test("Uppercase still maps correctly")
    func uppercase() {
        #expect(SchoolExamType(raw: "QUIZ") == .quiz)
    }

    @Test("Unknown values fall through to .other")
    func other() {
        #expect(SchoolExamType(raw: nil) == .other)
        #expect(SchoolExamType(raw: "diagnostic") == .other)
    }
}

@Suite("SchoolExamStatus")
struct SchoolExamStatusTests {

    @Test("Maps backend statuses", arguments: [
        ("SCHEDULED", SchoolExamStatus.scheduled),
        ("IN_PROGRESS", .inProgress),
        ("COMPLETED", .completed),
        ("CANCELLED", .cancelled),
    ])
    func mapsCanonical(raw: String, expected: SchoolExamStatus) {
        #expect(SchoolExamStatus(raw: raw) == expected)
    }

    @Test("Unknown for nil and junk")
    func unknown() {
        #expect(SchoolExamStatus(raw: nil) == .unknown)
        #expect(SchoolExamStatus(raw: "DELAYED") == .unknown)
    }
}

@Suite("SchoolExamDetail.passingPercent")
struct SchoolExamPassingPercentTests {

    @Test("Computes ratio when both present")
    func ratio() {
        let exam = make(total: 100, passing: 60)
        #expect(exam.passingPercent == 0.6)
    }

    @Test("Nil when total is zero or missing")
    func nilWhenZeroOrMissing() {
        #expect(make(total: 0, passing: 60).passingPercent == nil)
        #expect(make(total: nil, passing: 60).passingPercent == nil)
        #expect(make(total: 100, passing: nil).passingPercent == nil)
    }

    private func make(total: Int?, passing: Int?) -> SchoolExamDetail {
        SchoolExamDetail(
            id: "1", title: "T", description: nil,
            examDate: nil, startTime: nil, endTime: nil,
            duration: nil, totalMarks: total, passingMarks: passing,
            examType: nil, status: nil, instructions: nil,
            proctorMode: nil, shuffleQuestions: nil, maxAttempts: nil,
            subjectName: nil
        )
    }
}
