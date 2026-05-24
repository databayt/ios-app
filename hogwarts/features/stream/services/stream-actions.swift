import Foundation

final class StreamActions: Sendable {
    private let api = APIClient.shared

    // Catalog
    func listCourses(schoolId: String, category: String? = nil, grade: Int? = nil) async throws -> [Course] {
        var q: [String: String] = [:]
        if let category { q["category"] = category }
        if let grade { q["grade"] = String(grade) }
        return try await api.get("/mobile/stream/courses", query: q, as: [Course].self)
    }

    func featuredCourses(schoolId: String) async throws -> [Course] {
        try await api.get("/mobile/stream/featured", as: [Course].self)
    }

    func getCourse(id: String, schoolId: String) async throws -> Course {
        try await api.get("/mobile/stream/courses/\(id)", as: Course.self)
    }

    // Chapters / lessons
    func listChapters(courseId: String, schoolId: String) async throws -> [Chapter] {
        try await api.get("/mobile/stream/courses/\(courseId)/chapters", as: [Chapter].self)
    }

    func getLesson(id: String, schoolId: String) async throws -> StreamLesson {
        try await api.get("/mobile/stream/lessons/\(id)", as: StreamLesson.self)
    }

    func lessonQuiz(lessonId: String, schoolId: String) async throws -> [StreamQuizQuestion] {
        try await api.get("/mobile/stream/lessons/\(lessonId)/quiz", as: [StreamQuizQuestion].self)
    }

    // Progress
    func enroll(courseId: String, schoolId: String) async throws -> Enrollment {
        try await api.post("/mobile/stream/enrollments", body: ["courseId": courseId], as: Enrollment.self)
    }

    func markLessonComplete(lessonId: String, schoolId: String) async throws -> LessonProgress {
        try await api.post("/mobile/stream/lessons/\(lessonId)/complete", body: [String: String](), as: LessonProgress.self)
    }

    func submitQuiz(lessonId: String, answers: [Int], schoolId: String) async throws -> LessonProgress {
        try await api.post(
            "/mobile/stream/lessons/\(lessonId)/quiz/submit",
            body: ["answers": answers],
            as: LessonProgress.self
        )
    }

    func continueWatching(schoolId: String) async throws -> [Course] {
        try await api.get("/mobile/stream/continue-watching", as: [Course].self)
    }

    // Certificate
    func getCertificate(courseId: String, schoolId: String) async throws -> CourseCertificate {
        try await api.get("/mobile/stream/courses/\(courseId)/certificate", as: CourseCertificate.self)
    }
}
