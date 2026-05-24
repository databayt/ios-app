import Foundation
import Observation

@MainActor
@Observable
final class StreamHomeViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var featured: [Course] = []
    var continueWatching: [Course] = []
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do {
            async let f = actions.featuredCourses(schoolId: schoolId)
            async let cw = actions.continueWatching(schoolId: schoolId)
            self.featured = try await f
            self.continueWatching = try await cw
        } catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class CourseCatalogViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var courses: [Course] = []
    var category: String?
    var grade: Int?
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { courses = try await actions.listCourses(schoolId: schoolId, category: category, grade: grade) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class CourseDetailViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var course: Course?
    var chapters: [Chapter] = []
    var enrollment: Enrollment?
    var isLoading = false
    var isEnrolling = false
    var error: String?

    func load(id: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do {
            async let c = actions.getCourse(id: id, schoolId: schoolId)
            async let ch = actions.listChapters(courseId: id, schoolId: schoolId)
            self.course = try await c
            self.chapters = try await ch
        } catch { self.error = error.localizedDescription }
    }

    func enroll() async {
        guard let course, let schoolId = tenantContext?.currentSchoolId else { return }
        isEnrolling = true; defer { isEnrolling = false }
        do { enrollment = try await actions.enroll(courseId: course.id, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class ChapterListViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var chapters: [Chapter] = []
    var isLoading = false
    var error: String?

    func load(courseId: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { chapters = try await actions.listChapters(courseId: courseId, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class LessonViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var lesson: StreamLesson?
    var quiz: [StreamQuizQuestion] = []
    var quizAnswers: [Int?] = []
    var isLoading = false
    var didComplete = false
    var error: String?

    func load(id: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do {
            lesson = try await actions.getLesson(id: id, schoolId: schoolId)
            if lesson?.type == .quiz {
                quiz = try await actions.lessonQuiz(lessonId: id, schoolId: schoolId)
                quizAnswers = Array(repeating: nil, count: quiz.count)
            }
        } catch { self.error = error.localizedDescription }
    }

    func markComplete() async {
        guard let lesson, let schoolId = tenantContext?.currentSchoolId else { return }
        do { _ = try await actions.markLessonComplete(lessonId: lesson.id, schoolId: schoolId); didComplete = true }
        catch { self.error = error.localizedDescription }
    }

    func submitQuiz() async {
        guard let lesson, let schoolId = tenantContext?.currentSchoolId else { return }
        let answers = quizAnswers.compactMap { $0 }
        guard answers.count == quiz.count else { return }
        do { _ = try await actions.submitQuiz(lessonId: lesson.id, answers: answers, schoolId: schoolId); didComplete = true }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class CertificateViewModel {
    private let actions = StreamActions()
    var tenantContext: TenantContext?

    var certificate: CourseCertificate?
    var isLoading = false
    var error: String?

    func load(courseId: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { certificate = try await actions.getCertificate(courseId: courseId, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}
