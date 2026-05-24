import Foundation

final class QuizGameActions: Sendable {
    private let api = APIClient.shared

    func startSession(mode: QuizMode, subject: String?, difficulty: DifficultyLevel?, schoolId: String) async throws -> QuizSession {
        var body: [String: String] = ["mode": mode.rawValue]
        if let subject { body["subject"] = subject }
        if let difficulty { body["difficulty"] = difficulty.rawValue }
        return try await api.post("/mobile/quiz/sessions", body: body, as: QuizSession.self)
    }

    func submitAnswer(sessionId: String, questionId: String, answer: String, schoolId: String) async throws -> QuizSession {
        try await api.post(
            "/mobile/quiz/sessions/\(sessionId)/answer",
            body: ["questionId": questionId, "answer": answer],
            as: QuizSession.self
        )
    }

    func finishSession(sessionId: String, schoolId: String) async throws -> QuizResult {
        try await api.post("/mobile/quiz/sessions/\(sessionId)/finish", body: [String: String](), as: QuizResult.self)
    }

    func dailyChallenge(schoolId: String) async throws -> DailyChallenge {
        try await api.get("/mobile/quiz/daily-challenge", as: DailyChallenge.self)
    }

    func leaderboard(scope: String, schoolId: String) async throws -> [LeaderboardEntry] {
        try await api.get("/mobile/quiz/leaderboard", query: ["scope": scope], as: [LeaderboardEntry].self)
    }

    func achievements(schoolId: String) async throws -> [QuizAchievement] {
        try await api.get("/mobile/quiz/achievements", as: [QuizAchievement].self)
    }

    func tournaments(schoolId: String) async throws -> [Tournament] {
        try await api.get("/mobile/quiz/tournaments", as: [Tournament].self)
    }
}
