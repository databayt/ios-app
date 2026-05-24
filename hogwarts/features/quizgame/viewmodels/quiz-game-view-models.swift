import Foundation
import Observation

@MainActor
@Observable
final class GameHubViewModel {
    private let actions = QuizGameActions()
    var tenantContext: TenantContext?

    var dailyChallenge: DailyChallenge?
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { dailyChallenge = try await actions.dailyChallenge(schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class QuizSessionViewModel {
    private let actions = QuizGameActions()
    var tenantContext: TenantContext?

    var session: QuizSession?
    var result: QuizResult?
    var selectedAnswer: String?
    var showFeedback = false
    var isLoading = false
    var error: String?

    func start(mode: QuizMode, subject: String?, difficulty: DifficultyLevel?) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { session = try await actions.startSession(mode: mode, subject: subject, difficulty: difficulty, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }

    func submit() async {
        guard let session, let q = session.currentQuestion, let answer = selectedAnswer,
              let schoolId = tenantContext?.currentSchoolId else { return }
        do {
            self.session = try await actions.submitAnswer(sessionId: session.id, questionId: q.id, answer: answer, schoolId: schoolId)
            showFeedback = true
        } catch { self.error = error.localizedDescription }
    }

    func next() {
        showFeedback = false
        selectedAnswer = nil
        Task {
            if let s = session, s.isComplete {
                await finish(sessionId: s.id)
            }
        }
    }

    func finish(sessionId: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        do { result = try await actions.finishSession(sessionId: sessionId, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class LeaderboardViewModel {
    private let actions = QuizGameActions()
    var tenantContext: TenantContext?

    var entries: [LeaderboardEntry] = []
    var scope: String = "school"
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { entries = try await actions.leaderboard(scope: scope, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class AchievementsViewModel {
    private let actions = QuizGameActions()
    var tenantContext: TenantContext?

    var achievements: [QuizAchievement] = []
    var isLoading = false
    var error: String?

    var unlocked: [QuizAchievement] { achievements.filter(\.isUnlocked) }
    var locked: [QuizAchievement] { achievements.filter { !$0.isUnlocked } }

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { achievements = try await actions.achievements(schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class TournamentsViewModel {
    private let actions = QuizGameActions()
    var tenantContext: TenantContext?

    var tournaments: [Tournament] = []
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true; defer { isLoading = false }
        do { tournaments = try await actions.tournaments(schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}
