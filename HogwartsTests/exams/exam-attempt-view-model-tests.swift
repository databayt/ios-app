import Foundation
import Testing
@testable import Hogwarts

@Suite("ExamAttemptViewModel")
@MainActor
struct ExamAttemptViewModelTests {

    @Test("Navigation cursor stays in bounds")
    func navigationBounds() {
        let vm = makeVM(questionCount: 3)
        // Hydrate session manually so we can drive nav without a network call.
        vm._setSessionForTests(makeSession(count: 3))

        #expect(vm.currentIndex == 0)
        vm.goPrevious()                     // can't go below 0
        #expect(vm.currentIndex == 0)
        vm.goNext()
        #expect(vm.currentIndex == 1)
        vm.jump(to: 99)                     // out of range, no-op
        #expect(vm.currentIndex == 1)
        vm.jump(to: 2)
        #expect(vm.currentIndex == 2)
        vm.goNext()                         // can't go past last
        #expect(vm.currentIndex == 2)
    }

    @Test("Answer binding round-trips through the store")
    func answerBindingRoundtrip() {
        let vm = makeVM(questionCount: 2)
        vm._setSessionForTests(makeSession(count: 2))

        let binding = vm.answer(for: "q0")
        binding.wrappedValue = "B"
        #expect(vm.isAnswered("q0"))
        #expect(!vm.isAnswered("q1"))
        #expect(vm.answeredCount == 1)
    }

    @Test("Time formatter pads single digits")
    func timeFormatPadding() {
        let vm = makeVM(questionCount: 1)
        vm._setSessionForTests(makeSession(count: 1, durationSec: 65))
        // 65 → "01:05"
        #expect(vm.timeRemainingFormatted == "01:05")
    }

    // MARK: - Helpers

    private func makeVM(questionCount: Int) -> ExamAttemptViewModel {
        ExamAttemptViewModel(examId: "exam-id")
    }

    private func makeSession(count: Int, durationSec: Int = 600) -> ExamSessionStart {
        let questions = (0..<count).map { i in
            ExamQuestion(
                id: "q\(i)",
                text: "Question \(i)",
                type: "MULTIPLE_CHOICE",
                options: nil,
                marks: 1,
                order: i
            )
        }
        return ExamSessionStart(
            sessionId: "sess",
            examId: "exam-id",
            title: "Test exam",
            duration: 60,
            totalMarks: count,
            instructions: nil,
            timeRemaining: durationSec,
            questions: questions
        )
    }
}

// Test-only mutation entry point so we don't need a network mock just to
// drive navigation and answer-binding behaviour.
extension ExamAttemptViewModel {
    func _setSessionForTests(_ session: ExamSessionStart) {
        // Use Mirror-free, direct write via the model's internal setter
        // path — the @Observable macro generates synthesized setters
        // accessible from the same module under @testable import.
        self.session = session
        self.timeRemaining = session.timeRemaining
        self.phase = .taking
    }
}
