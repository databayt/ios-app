import Foundation
import SwiftUI

/// `/lumos/courses/[slug]/[lessonId]` — one lesson: the player, the lesson's
/// own words, its quiz, its resources and its siblings.
@MainActor
@Observable
final class LumosLessonViewModel {
    private(set) var page: LessonPage?
    private(set) var isLoading = false
    private(set) var lastError: String?

    /// The signed URL the player opens — a protected `/api/lumos/...` path is
    /// resolved with this app's token first.
    private(set) var playURL: URL?
    private(set) var isResolvingMedia = false

    private(set) var isCompleted = false
    private(set) var isCompleting = false

    // Quiz
    private(set) var choices: [String: Int] = [:]
    private(set) var texts: [String: String] = [:]
    private(set) var isSubmitting = false
    private(set) var quizError: String?
    private(set) var grade: QuizGrade?

    /// One attempt id per lesson page, so a repeated submit is one attempt.
    private let attemptId = UUID().uuidString

    private let actions: LumosActions
    private let api: APIClient
    private let lessonId: String
    /// The course the page was opened from — quiz grading and progress need it.
    private let courseSlug: String

    init(courseSlug: String, lessonId: String, actions: LumosActions = .init()) {
        self.courseSlug = courseSlug
        self.lessonId = lessonId
        self.actions = actions
        self.api = APIClient.shared
    }

    var quizQuestions: [LessonQuizQuestion] { page?.quiz ?? [] }

    /// A free-text question has no choices.
    func isTextQuestion(_ question: LessonQuizQuestion) -> Bool {
        question.choices?.isEmpty ?? true
    }

    var allAnswered: Bool {
        quizQuestions.allSatisfy { question in
            isTextQuestion(question)
                ? !(texts[question.id] ?? "").trimmingCharacters(in: .whitespaces).isEmpty
                : choices[question.id] != nil
        }
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            let page = try await actions.lesson(id: lessonId)
            self.page = page
            isCompleted = page.progress?.isCompleted ?? false
            if let url = page.videoUrl, !url.isEmpty {
                playURL = await api.resolveMediaURL(url)
            }
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Resolve a resource's link: protected paths become signed URLs, the rest
    /// pass through.
    func resourceURL(_ resource: LumosLessonResource) async -> URL? {
        guard let raw = resource.url, !raw.isEmpty else { return nil }
        guard raw.hasPrefix("/") else { return URL(string: raw) }
        isResolvingMedia = true
        defer { isResolvingMedia = false }
        return await api.resolveMediaURL(raw)
    }

    /// The marketing clip must never write progress, so its lesson is not
    /// marked complete by watching it.
    func markComplete() async {
        guard let page, !isCompleted, !isCompleting, !page.isFallbackVideo else { return }
        isCompleting = true
        defer { isCompleting = false }
        do {
            try await actions.saveProgress(courseId: page.course.id, lessonId: page.id, status: "COMPLETED")
            isCompleted = true
        } catch {
            // A lost completion is retried the next time the lesson is opened.
        }
    }

    func choose(_ index: Int, for questionId: String) {
        choices[questionId] = index
    }

    func type(_ text: String, for questionId: String) {
        texts[questionId] = text
    }

    func submitQuiz() async {
        guard let page, !isSubmitting else { return }
        isSubmitting = true
        quizError = nil
        defer { isSubmitting = false }

        var answers: [String: QuizAnswer] = [:]
        for (id, index) in choices { answers[id] = .index(index) }
        for (id, text) in texts where !text.trimmingCharacters(in: .whitespaces).isEmpty {
            answers[id] = .text(text)
        }
        do {
            grade = try await actions.gradeQuiz(
                courseId: page.course.id,
                lessonId: page.id,
                answers: answers,
                attemptId: attemptId
            )
        } catch {
            quizError = page.labels["quiz_failed"] ?? String(localized: "lumos.quiz.failed")
        }
    }

    func verdict(for questionId: String) -> QuizVerdict? {
        grade?.verdicts.first(where: { $0.questionId == questionId })
    }
}
