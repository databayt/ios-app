import Foundation

/// Type definitions for Students feature
/// Mirrors: src/components/platform/students/types.ts

// MARK: - Request Types

/// Create student request
struct StudentCreateRequest: Encodable {
    let grNumber: String
    let givenName: String
    let surname: String
    let givenNameAr: String?
    let surnameAr: String?
    let dateOfBirth: Date?
    let gender: String?
    let nationality: String?
    let email: String?
    let phone: String?
    let address: String?
    let yearLevelId: String?
    let batchId: String?
    let guardianId: String?
}

/// Update student request
struct StudentUpdateRequest: Encodable {
    let givenName: String?
    let surname: String?
    let givenNameAr: String?
    let surnameAr: String?
    let dateOfBirth: Date?
    let gender: String?
    let nationality: String?
    let email: String?
    let phone: String?
    let address: String?
    let yearLevelId: String?
    let batchId: String?
    let status: String?
    let photoUrl: String?
    let bloodType: String?
    let allergies: String?
    let medicalConditions: String?
}

// MARK: - Filter Types

/// Student list filters
/// Web API: GET /mobile/students?search=X&section_id=Y&status=Z&page=N&per_page=N
struct StudentFilters {
    var search: String?
    var status: StudentStatus?
    var sectionId: String?
    var page: Int = 1
    var perPage: Int = 20

    /// Convert to query parameters matching the web API
    var queryParams: [String: String] {
        var params: [String: String] = [:]

        if let search = search, !search.isEmpty {
            params["search"] = search
        }
        if let status = status {
            params["status"] = status.rawValue
        }
        if let sectionId = sectionId {
            params["section_id"] = sectionId
        }

        params["page"] = String(page)
        params["per_page"] = String(perPage)

        return params
    }
}

// MARK: - View State

/// Students list view state
enum StudentsViewState {
    case idle
    case loading
    case loaded([Student])
    case error(Error)
    case empty

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var students: [Student] {
        if case .loaded(let students) = self { return students }
        return []
    }
}

/// Student form mode
enum StudentFormMode {
    case create
    case edit(Student)

    var title: String {
        switch self {
        case .create:
            return String(localized: "student.form.createTitle")
        case .edit:
            return String(localized: "student.form.editTitle")
        }
    }

    var student: Student? {
        if case .edit(let student) = self { return student }
        return nil
    }
}

// MARK: - SwiftData Conversion

extension Student {
    /// Create API model from SwiftData model (for offline reads)
    init(from model: StudentModel) {
        self.init(
            id: model.id,
            grNumber: model.grNumber,
            userId: model.userId,
            schoolId: model.schoolId,
            yearLevelId: model.yearLevelId,
            batchId: model.batchId,
            status: model.status,
            givenName: model.givenName,
            surname: model.surname,
            givenNameAr: model.givenNameAr,
            surnameAr: model.surnameAr,
            dateOfBirth: model.dateOfBirth,
            gender: model.gender,
            nationality: model.nationality,
            photoUrl: model.photoUrl,
            email: model.email,
            phone: model.phone,
            address: model.address,
            bloodType: model.bloodType,
            allergies: model.allergies,
            medicalConditions: model.medicalConditions,
            createdAt: nil,
            updatedAt: nil,
            user: nil,
            yearLevel: nil
        )
    }
}

// MARK: - Table Row

/// Row type for students table
/// Mirrors: Column definitions in columns.tsx
struct StudentRow: Identifiable, Hashable {
    let id: String
    let grNumber: String
    let name: String
    let nameAr: String?
    let email: String?
    let phone: String?
    let status: StudentStatus
    let yearLevel: String?
    let photoUrl: String?

    init(from student: Student) {
        self.id = student.id
        self.grNumber = student.grNumber
        self.name = student.fullName
        self.nameAr = [student.givenNameAr, student.surnameAr]
            .compactMap { $0 }
            .joined(separator: " ")
        self.email = student.email
        self.phone = student.phone
        self.status = student.studentStatus
        self.yearLevel = student.yearLevel?.name
        self.photoUrl = student.photoUrl
    }
}
