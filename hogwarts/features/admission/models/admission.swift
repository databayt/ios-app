import Foundation

enum ApplicationStatus: String, Codable, CaseIterable {
    case draft
    case submitted
    case underReview = "under_review"
    case interviewScheduled = "interview_scheduled"
    case accepted
    case rejected
    case waitlisted

    var displayName: String {
        switch self {
        case .draft: String(localized: "admission.status.draft")
        case .submitted: String(localized: "admission.status.submitted")
        case .underReview: String(localized: "admission.status.under_review")
        case .interviewScheduled: String(localized: "admission.status.interview")
        case .accepted: String(localized: "admission.status.accepted")
        case .rejected: String(localized: "admission.status.rejected")
        case .waitlisted: String(localized: "admission.status.waitlisted")
        }
    }
}

enum ApplicationStep: Int, Codable, CaseIterable, Identifiable {
    case personalInfo = 1
    case contactInfo = 2
    case guardianInfo = 3
    case academicHistory = 4
    case documents = 5
    case review = 6

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .personalInfo:    String(localized: "admission.step.personal")
        case .contactInfo:     String(localized: "admission.step.contact")
        case .guardianInfo:    String(localized: "admission.step.guardian")
        case .academicHistory: String(localized: "admission.step.academic")
        case .documents:       String(localized: "admission.step.documents")
        case .review:          String(localized: "admission.step.review")
        }
    }
}

struct PersonalInfo: Codable, Equatable {
    var givenNameEn: String = ""
    var familyNameEn: String = ""
    var givenNameAr: String = ""
    var familyNameAr: String = ""
    var dateOfBirth: String = ""
    var gender: String = ""
    var nationality: String = ""
    var nationalId: String = ""
}

struct ContactInfo: Codable, Equatable {
    var address: String = ""
    var city: String = ""
    var countryCode: String = "+966"
    var phone: String = ""
    var email: String = ""
}

struct GuardianInfo: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var relationship: String = ""
    var occupation: String = ""
    var phone: String = ""
    var email: String = ""
}

struct AcademicHistory: Codable, Equatable {
    var previousSchool: String = ""
    var lastGrade: String = ""
    var applyingGrade: String = ""
    var hasSpecialNeeds: Bool = false
    var specialNeedsDetails: String = ""
}

struct AdmissionDocument: Codable, Equatable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var type: String
    var url: String = ""
    var uploadedAt: String? = nil
}

struct AdmissionApplication: Codable, Equatable, Identifiable {
    var id: String = UUID().uuidString
    var trackingNumber: String? = nil
    var status: ApplicationStatus = .draft
    var currentStep: ApplicationStep = .personalInfo
    var personalInfo: PersonalInfo = PersonalInfo()
    var contactInfo: ContactInfo = ContactInfo()
    var guardians: [GuardianInfo] = []
    var academicHistory: AcademicHistory = AcademicHistory()
    var documents: [AdmissionDocument] = []
    var createdAt: String? = nil
    var updatedAt: String? = nil
}
