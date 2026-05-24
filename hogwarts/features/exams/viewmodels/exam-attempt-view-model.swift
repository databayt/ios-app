import Foundation
import SwiftUI

// MARK: - ExamAttemptViewModel
//
// Owns the running exam session: countdown timer, per-question answer
// store, navigation cursor, submit flow. The timer is a single
// `Task.sleep` loop so backgrounding pauses correctly when the view
// disappears (the parent `.task` cancels it).

@MainActor
@Observable
final class ExamAttemptViewModel {
    enum Phase: Hashable, Sendable {
        case loading
        case taking
        case submitting
        case submitted(ExamSubmissionResponse)
        case error(String)
    }

    private(set) var phase: Phase = .loading
    private(set) var session: ExamSessionStart?
    /// Remaining time in seconds — drives the toolbar pill + auto-submit.
    private(set) var timeRemaining: Int = 0
    private(set) var currentIndex: Int = 0
    /// Map of questionID → answer (MCQ option key or free text).
    private var answers: [String: String] = [:]

    private let actions: ExamsActions
    private let examId: String

    init(examId: String, actions: ExamsActions = .init()) {
        self.examId = examId
        self.actions = actions
    }

    var totalCount: Int { session?.questions.count ?? 0 }
    var currentQuestion: ExamQuestion? {
        guard let session, session.questions.indices.contains(currentIndex) else { return nil }
        return session.questions[currentIndex]
    }
    var answeredCount: Int { answers.values.filter { !$0.isEmpty }.count }
    var canSubmit: Bool { totalCount > 0 }

    /// Bound by the question views — read/write per question.
    func answer(for questionId: String) -> Binding<String> {
        Binding(
            get: { self.answers[questionId] ?? "" },
            set: { self.answers[questionId] = $0 }
        )
    }

    /// Convenience for badge "answered" indicators in the question list.
    func isAnswered(_ questionId: String) -> Bool {
        !(answers[questionId]?.isEmpty ?? true)
    }

    // MARK: - Lifecycle

    func start() async {
        phase = .loading
        do {
            let session = try await actions.startOnline(examId: examId)
            self.session = session
            self.timeRemaining = max(0, session.timeRemaining)
            self.currentIndex = 0
            self.answers = [:]
            self.phase = .taking
            await runTimer()
        } catch is CancellationError {
            // ignore
        } catch {
            phase = .error(error.localizedDescription)
        }
    }

    /// Sleep-loop countdown. Auto-submits when it reaches zero.
    private func runTimer() async {
        while timeRemaining > 0, case .taking = phase {
            try? await Task.sleep(for: .seconds(1))
            if Task.isCancelled { return }
            if case .taking = phase, timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        if timeRemaining == 0, case .taking = phase {
            await submit(isAuto: true)
        }
    }

    // MARK: - Navigation

    func goNext() {
        guard currentIndex < totalCount - 1 else { return }
        currentIndex += 1
    }

    func goPrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func jump(to index: Int) {
        guard (0..<totalCount).contains(index) else { return }
        currentIndex = index
    }

    // MARK: - Submit

    func submit(isAuto: Bool = false) async {
        guard let session else { return }
        phase = .submitting
        let entries: [ExamAnswerEntry] = session.questions.map { q in
            ExamAnswerEntry(questionId: q.id, answer: answers[q.id] ?? "")
        }
        do {
            let response = try await actions.submitAnswers(
                examId: examId,
                sessionId: session.sessionId,
                answers: entries
            )
            phase = .submitted(response)
        } catch is CancellationError {
            // ignore
        } catch {
            phase = .error(error.localizedDescription)
        }
    }

    // MARK: - Display helpers

    /// "12:34" — pre-formatted for the timer pill.
    var timeRemainingFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Color coding for the timer pill — green > 30 % / amber > 10 % / red.
    var timeRemainingColor: Color {
        guard let session, session.duration > 0 else { return .accentBlue }
        let total = session.duration * 60
        let ratio = Double(timeRemaining) / Double(total)
        if ratio > 0.30 { return .accentGreen }
        if ratio > 0.10 { return .accentOrange }
        return .accentRed
    }
}
