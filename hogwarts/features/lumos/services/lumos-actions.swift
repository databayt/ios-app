import Foundation

/// Lumos (LMS) endpoints. Every call goes through `APIClient`, so the bearer
/// token and the school scoping are the app's, never a query parameter.
///
/// Truth: `/api/mobile/lumos/*` and `/api/mobile/courses/*` (hogwarts
/// `src/app/api/mobile/`). Mirrors Android `lumos-api.kt` / `lumos-repository-impl.kt`.
final class LumosActions: Sendable {
    private let api: APIClient

    init(api: APIClient = APIClient.shared) {
        self.api = api
    }

    /// The wire language: the phone's, `en` or else `ar` (the web's two).
    static var wireLanguage: String {
        Locale.current.language.languageCode?.identifier == "en" ? "en" : "ar"
    }

    /// `GET /mobile/lumos/courses` — the browse page: one shelf per grade, the
    /// reader's own grade, and what to watch next. `level` picks a grade;
    /// without it the server uses the reader's.
    func coursesPage(level: Int? = nil, page: Int? = nil) async throws -> LumosCoursesPage {
        var query: [String: String] = ["lang": Self.wireLanguage]
        if let level { query["level"] = String(level) }
        if let page { query["page"] = String(page) }
        return try await api.get("/mobile/lumos/courses", query: query, as: LumosCoursesPage.self)
    }

    /// `GET /mobile/lumos/courses/{slug}` — the course page: chapters, the
    /// reader's progress, and the page's own words.
    func course(slug: String) async throws -> CoursePage {
        try await api.get(
            "/mobile/lumos/courses/\(slug)",
            query: ["lang": Self.wireLanguage],
            as: CoursePage.self
        )
    }

    /// `GET /mobile/lumos/lessons/{id}` — one lesson: its video, quiz,
    /// resources and siblings.
    func lesson(id: String) async throws -> LessonPage {
        try await api.get(
            "/mobile/lumos/lessons/\(id)",
            query: ["lang": Self.wireLanguage],
            as: LessonPage.self
        )
    }

    /// `GET /mobile/lumos/course-search` — the search sheet. A query is the
    /// typeahead; no query is the sheet's featured shelf.
    func search(query: String? = nil, grade: Int? = nil, perPage: Int? = nil) async throws -> CourseSearch {
        var params: [String: String] = ["locale": Self.wireLanguage]
        if let query, !query.isEmpty { params["q"] = query }
        if let grade { params["grade"] = String(grade) }
        if let perPage { params["perPage"] = String(perPage) }
        return try await api.get("/mobile/lumos/course-search", query: params, as: CourseSearch.self)
    }

    /// `POST /mobile/courses/{courseId}/enroll`. A paid subject refuses with
    /// 402 and its price, and the app sends the reader to the web to pay.
    func enroll(courseId: String) async throws -> CourseEnrollment {
        do {
            return try await api.post(
                "/mobile/courses/\(courseId)/enroll",
                body: EmptyBody(),
                as: CourseEnrollment.self
            )
        } catch let error as APIError {
            if case .serverError(402) = error { throw LumosError.paymentRequired }
            if case .serverError(409) = error { throw LumosError.alreadyEnrolled }
            throw error
        }
    }

    /// `POST /mobile/courses/{courseId}/lessons/{lessonId}/progress` — a watch
    /// sample, or `COMPLETED`, which is what issues the certificate.
    func saveProgress(
        courseId: String,
        lessonId: String,
        status: String,
        watchedSeconds: Int = 0,
        totalSeconds: Int = 0
    ) async throws {
        let body = LessonProgressUpdate(
            lessonId: lessonId,
            status: status,
            watchedSeconds: watchedSeconds,
            totalSeconds: totalSeconds
        )
        let _: LessonProgressUpdate = try await api.post(
            "/mobile/courses/\(courseId)/lessons/\(lessonId)/progress",
            body: body,
            as: LessonProgressUpdate.self
        )
    }

    /// `POST /mobile/courses/{courseId}/lessons/{lessonId}/quiz` — grades the
    /// quiz and reveals the verdicts. An index is a chosen option; a string is
    /// a free-text answer.
    func gradeQuiz(
        courseId: String,
        lessonId: String,
        answers: [String: QuizAnswer],
        attemptId: String
    ) async throws -> QuizGrade {
        let body = QuizSubmission(answers: answers, attemptId: attemptId)
        return try await api.post(
            "/mobile/courses/\(courseId)/lessons/\(lessonId)/quiz",
            body: body,
            as: QuizGrade.self
        )
    }

    /// `GET /mobile/courses/{courseId}/certificate` — 404 until the last
    /// published lesson is finished, which is the truthful answer.
    func certificate(courseId: String) async throws -> LumosCertificate {
        try await api.get(
            "/mobile/courses/\(courseId)/certificate",
            as: LumosCertificate.self
        )
    }
}

// MARK: - Request bodies

private struct EmptyBody: Encodable {}

/// Wire shape of the progress sample — snake_case, as the route reads it.
struct LessonProgressUpdate: Codable, Sendable {
    var lessonId: String
    var status: String
    var watchedSeconds: Int
    var totalSeconds: Int

    enum CodingKeys: String, CodingKey {
        case status
        case lessonId = "lesson_id"
        case watchedSeconds = "watched_seconds"
        case totalSeconds = "total_seconds"
    }
}

/// One answer: the chosen option's index, or the free-text the reader typed.
enum QuizAnswer: Encodable, Sendable, Hashable {
    case index(Int)
    case text(String)

    func encode(to encoder: Encoder) throws {
        var single = encoder.singleValueContainer()
        switch self {
        case .index(let value): try single.encode(value)
        case .text(let value): try single.encode(value)
        }
    }
}

private struct QuizSubmission: Encodable {
    let answers: [String: QuizAnswer]
    let attemptId: String

    enum CodingKeys: String, CodingKey {
        case answers
        case attemptId = "attempt_id"
    }
}

/// The enrolment row the enroll route returns.
struct CourseEnrollment: Decodable, Sendable {
    var id: String = ""
    var courseId: String = ""
    var userId: String = ""
    var progress: Double = 0

    enum CodingKeys: String, CodingKey {
        case id, progress
        case courseId = "course_id"
        case userId = "user_id"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        courseId = c.lenient(.courseId, "")
        userId = c.lenient(.userId, "")
        progress = c.lenient(.progress, 0)
    }
}

/// What enrolling can mean when it does not simply succeed.
enum LumosError: LocalizedError {
    case paymentRequired
    case alreadyEnrolled

    var errorDescription: String? {
        switch self {
        case .paymentRequired: String(localized: "lumos.enroll.paymentRequired")
        case .alreadyEnrolled: String(localized: "lumos.enroll.alreadyEnrolled")
        }
    }
}
