import Foundation

enum QuizMode: String, Codable, CaseIterable, Identifiable {
    case practice, timed, challenge, tournament
    var id: String { rawValue }
}

enum QuestionType: String, Codable {
    case multipleChoice = "multiple_choice"
    case trueFalse = "true_false"
    case shortAnswer = "short_answer"
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy, medium, hard
}

struct QuizQuestion: Codable, Equatable, Identifiable {
    let id: String
    let text: String
    let type: QuestionType
    let options: [String]
    let correctAnswer: String
    let explanation: String?
    let subject: String
    let topic: String
    let difficulty: DifficultyLevel
    let points: Int
}

struct QuizSession: Codable, Equatable, Identifiable {
    let id: String
    let mode: QuizMode
    let questions: [QuizQuestion]
    var currentIndex: Int
    var score: Int
    var streakCount: Int
    let startedAt: Date
    let timeLimitSeconds: Int?
    var answers: [String: String]

    var isComplete: Bool { currentIndex >= questions.count }
    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }
}

struct QuizAchievement: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let description: String
    let iconName: String
    let unlockedAt: Date?
    let progress: Double
    let category: String

    var isUnlocked: Bool { unlockedAt != nil }
}

struct QuizResult: Codable, Equatable, Identifiable {
    let sessionId: String
    let mode: QuizMode
    let totalQuestions: Int
    let correctAnswers: Int
    let score: Int
    let timeTakenSeconds: Int
    let accuracy: Double
    let xpEarned: Int
    let streakBonus: Int
    let newAchievements: [QuizAchievement]

    var id: String { sessionId }
}

struct LeaderboardEntry: Codable, Equatable, Identifiable {
    let rank: Int
    let userId: String
    let userName: String
    let avatarUrl: String?
    let score: Int
    let gamesPlayed: Int
    let winRate: Double

    var id: String { userId }
}

enum TournamentStatus: String, Codable {
    case upcoming, inProgress = "in_progress", completed
}

struct TournamentMatch: Codable, Equatable, Identifiable {
    let id: String
    let round: Int
    let player1Id: String?
    let player1Name: String?
    let player2Id: String?
    let player2Name: String?
    let winnerId: String?
    let player1Score: Int
    let player2Score: Int
}

struct Tournament: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let subject: String
    let startDate: Date
    let endDate: Date
    let currentRound: Int
    let totalRounds: Int
    let participants: Int
    let status: TournamentStatus
    let bracket: [TournamentMatch]
}

struct DailyChallenge: Codable, Equatable, Identifiable {
    let id: String
    let date: String
    let subject: String
    let questionCount: Int
    let difficulty: DifficultyLevel
    let completed: Bool
    let reward: Int
}
