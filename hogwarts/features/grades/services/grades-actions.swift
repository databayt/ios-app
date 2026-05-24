import Foundation

/// Server actions for Grades feature
/// Mirrors: src/components/platform/grades/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class GradesActions: Sendable {

    private let api = APIClient.shared
    private let syncEngine = SyncEngine.shared

    // MARK: - Read Actions

    /// Get grades/results for a student (paginated)
    /// Web API: GET /mobile/grades/student/{studentId}?page=N&per_page=N
    /// Returns: {data: [{id, title, description, score, max_score, percentage,
    ///   grade, feedback, submitted_at, graded_at, subject_name}], total, page, per_page}
    func getStudentGrades(
        studentId: String,
        schoolId: String,
        page: Int = 1,
        perPage: Int = 20
    ) async throws -> StudentGradesResponse {
        let params: [String: String] = [
            "page": String(page),
            "per_page": String(perPage)
        ]

        return try await api.get(
            "/mobile/grades/student/\(studentId)",
            query: params,
            as: StudentGradesResponse.self
        )
    }

    /// Get grade summary for a student
    /// Web API: GET /mobile/grades/summary/{studentId}
    /// Returns: {total_results, average_percentage, gpa, overall_grade,
    ///   rank, total_students, subjects: [...]}
    func getStudentGradeSummary(
        studentId: String,
        schoolId: String
    ) async throws -> GradeSummaryResponse {
        return try await api.get(
            "/mobile/grades/summary/\(studentId)",
            as: GradeSummaryResponse.self
        )
    }

    /// Get exams list (paginated)
    /// Web API: GET /mobile/exams?status=X&upcoming=true&page=N&per_page=N
    func getExams(
        schoolId: String,
        status: String? = nil,
        upcoming: Bool? = nil,
        page: Int = 1,
        perPage: Int = 20
    ) async throws -> ExamsResponse {
        var params: [String: String] = [
            "page": String(page),
            "per_page": String(perPage)
        ]
        if let status { params["status"] = status }
        if let upcoming { params["upcoming"] = String(upcoming) }

        return try await api.get("/mobile/exams", query: params, as: ExamsResponse.self)
    }

    /// Get single exam detail
    /// Web API: GET /mobile/exams/{id}
    func getExam(
        examId: String,
        schoolId: String
    ) async throws -> Exam {
        return try await api.get("/mobile/exams/\(examId)", as: Exam.self)
    }

    /// Get subjects
    /// Web API: GET /mobile/subjects?search=X&department=Y&lang=Z
    func getSubjects(
        schoolId: String,
        search: String? = nil,
        department: String? = nil,
        lang: String? = nil
    ) async throws -> [SubjectInfo] {
        var params: [String: String] = [:]
        if let search { params["search"] = search }
        if let department { params["department"] = department }
        if let lang { params["lang"] = lang }

        return try await api.get("/mobile/subjects", query: params, as: [SubjectInfo].self)
    }

    // NOTE: createExam, submitMarks (bulk results), publishResults do not exist
    // as mobile API endpoints. Exam/grade management is done via the web admin.
    // The mobile API is read-only for grades.
}

// MARK: - Errors

enum GradesError: LocalizedError {
    case validationFailed([String: String])
    case notFound
    case unauthorized
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return errors.values.joined(separator: ", ")
        case .notFound:
            return String(localized: "grade.error.notFound")
        case .unauthorized:
            return String(localized: "error.unauthorized")
        case .serverError(let message):
            return message
        }
    }
}
