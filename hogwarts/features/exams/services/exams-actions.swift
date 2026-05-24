import Foundation

/// Server actions for the Exams feature.
final class ExamsActions: Sendable {
    private let api = APIClient.shared

    /// Paginated exam list — `upcoming = true` filters to today and forward.
    func list(
        upcoming: Bool = false,
        status: SchoolExamStatus? = nil,
        page: Int = 1,
        perPage: Int = 30
    ) async throws -> SchoolExamsListResponse {
        var query: [String: String] = [
            "page": String(page),
            "per_page": String(perPage),
        ]
        if upcoming { query["upcoming"] = "true" }
        if let status, status != .unknown {
            // Backend uses upper-snake for `status`.
            switch status {
            case .scheduled:  query["status"] = "SCHEDULED"
            case .inProgress: query["status"] = "IN_PROGRESS"
            case .completed:  query["status"] = "COMPLETED"
            case .cancelled:  query["status"] = "CANCELLED"
            case .unknown:    break
            }
        }
        return try await api.get(
            "/mobile/exams",
            query: query,
            as: SchoolExamsListResponse.self
        )
    }

    /// Full exam metadata (proctor mode, shuffle, max attempts).
    func detail(id: String) async throws -> SchoolExamDetail {
        try await api.get("/mobile/exams/\(id)", as: SchoolExamDetail.self)
    }

    // MARK: - Online attempt

    /// Start (or resume) the online attempt — backend creates an
    /// `ExamSession` and returns the questions + remaining seconds.
    /// POSTs an empty body since the route only needs the JWT identity.
    func startOnline(examId: String) async throws -> ExamSessionStart {
        struct Empty: Encodable {}
        return try await api.post(
            "/mobile/exams/\(examId)/online",
            body: Empty(),
            as: ExamSessionStart.self
        )
    }

    /// Submit answers — backend auto-grades MCQ + true/false and marks
    /// the session as `SUBMITTED`.
    func submitAnswers(
        examId: String,
        sessionId: String,
        answers: [ExamAnswerEntry]
    ) async throws -> ExamSubmissionResponse {
        try await api.post(
            "/mobile/exams/\(examId)/answers",
            body: ExamAnswerSubmission(sessionId: sessionId, answers: answers),
            as: ExamSubmissionResponse.self
        )
    }

    /// Final graded result — call after submission has been graded
    /// (essays may take a teacher's review before this is available).
    func result(examId: String) async throws -> ExamResult {
        try await api.get("/mobile/exams/\(examId)/results", as: ExamResult.self)
    }
}
