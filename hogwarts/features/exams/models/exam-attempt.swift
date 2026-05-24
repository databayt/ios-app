import SwiftUI

// MARK: - DTOs
//
// Mirrors `/api/mobile/exams/:id/online` (start session — returns
// questions + time_remaining), `/answers` (submit), and `/results`
// (graded result for review).

struct ExamSessionStart: Codable, Sendable {
    let sessionId: String
    let examId: String
    let title: String
    let duration: Int
    let totalMarks: Int
    let instructions: String?
    let timeRemaining: Int
    let questions: [ExamQuestion]
}

struct ExamQuestion: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let text: String
    let type: String
    /// JSON-encoded option list — backend ships this loose for MCQ.
    /// We decode lazily via `optionsList` so we don't hard-couple to a shape.
    let options: ExamOptionsBlob?
    let marks: Int
    let order: Int

    var typeKind: ExamQuestionType { ExamQuestionType(raw: type) }

    /// Best-effort options list — empty for non-MCQ types.
    var optionsList: [ExamOption] {
        guard let options else { return [] }
        return options.asOptionList
    }
}

/// Wrapper that accepts either `[String]` or `[{key, text}]` from the
/// backend. We never know which one ships, so the type stays loose.
struct ExamOptionsBlob: Codable, Hashable, @unchecked Sendable {
    private let raw: AnyCodable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        raw = try container.decode(AnyCodable.self)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
    var asOptionList: [ExamOption] {
        switch raw.value {
        case let arr as [Any]:
            return arr.enumerated().compactMap { idx, item in
                if let s = item as? String {
                    return ExamOption(key: String(UnicodeScalar(65 + idx) ?? "A"), text: s)
                }
                if let dict = item as? [String: Any] {
                    let key = dict["key"] as? String
                        ?? dict["id"] as? String
                        ?? String(UnicodeScalar(65 + idx) ?? "A")
                    let text = dict["text"] as? String
                        ?? dict["label"] as? String
                        ?? dict["value"] as? String
                        ?? ""
                    return ExamOption(key: key, text: text)
                }
                return nil
            }
        default:
            return []
        }
    }
}

struct ExamOption: Identifiable, Hashable, Sendable {
    var id: String { key }
    let key: String
    let text: String
}

/// Type-erased Codable shim. Keeps the options blob roundtrippable
/// without committing to a wire shape we don't control.
///
/// `@unchecked Sendable`: the `value: Any` storage means the compiler
/// can't prove sendability, but every `init` only stores Codable-derived
/// primitives (Bool/Int/Double/String/Array/Dict of these), so the value
/// is in practice immutable + safe to share across actors.
struct AnyCodable: Codable, Hashable, @unchecked Sendable {
    let value: Any

    init(_ value: Any) { self.value = value }

    static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        // Best-effort equality via JSON encoding — used for SwiftUI diffing only.
        guard
            let l = try? JSONSerialization.data(withJSONObject: lhs.normalized),
            let r = try? JSONSerialization.data(withJSONObject: rhs.normalized)
        else { return false }
        return l == r
    }

    func hash(into hasher: inout Hasher) {
        if let data = try? JSONSerialization.data(withJSONObject: normalized) {
            hasher.combine(data)
        }
    }

    private var normalized: Any {
        // Foundation's JSONSerialization needs a JSON-friendly object graph.
        if JSONSerialization.isValidJSONObject([value]) { return value }
        return "\(value)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let v = try? container.decode(Bool.self) {
            value = v
        } else if let v = try? container.decode(Int.self) {
            value = v
        } else if let v = try? container.decode(Double.self) {
            value = v
        } else if let v = try? container.decode(String.self) {
            value = v
        } else if let v = try? container.decode([AnyCodable].self) {
            value = v.map(\.value)
        } else if let v = try? container.decode([String: AnyCodable].self) {
            value = v.mapValues(\.value)
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:                     try container.encodeNil()
        case let v as Bool:                 try container.encode(v)
        case let v as Int:                  try container.encode(v)
        case let v as Double:               try container.encode(v)
        case let v as String:               try container.encode(v)
        case let v as [Any]:                try container.encode(v.map(AnyCodable.init))
        case let v as [String: Any]:        try container.encode(v.mapValues(AnyCodable.init))
        default:                            try container.encodeNil()
        }
    }
}

enum ExamQuestionType: Sendable, Hashable {
    case multipleChoice
    case trueFalse
    case shortAnswer
    case essay
    case unknown(String)

    init(raw: String) {
        switch raw.uppercased() {
        case "MULTIPLE_CHOICE", "MCQ":  self = .multipleChoice
        case "TRUE_FALSE", "TRUEFALSE": self = .trueFalse
        case "SHORT_ANSWER":            self = .shortAnswer
        case "ESSAY", "LONG_ANSWER":    self = .essay
        default:                        self = .unknown(raw)
        }
    }

    var isMultipleChoice: Bool {
        if case .multipleChoice = self { return true }
        return false
    }

    var isTextResponse: Bool {
        switch self {
        case .shortAnswer, .essay: return true
        default: return false
        }
    }
}

// MARK: - Submit / Result

struct ExamAnswerSubmission: Codable, Sendable {
    let sessionId: String
    let answers: [ExamAnswerEntry]

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case answers
    }
}

struct ExamAnswerEntry: Codable, Sendable {
    let questionId: String
    /// Either a single string (MCQ key, free text) or an array — backend
    /// accepts both; we always submit a single value here.
    let answer: String

    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case answer
    }
}

struct ExamSubmissionResponse: Codable, Sendable {
    let submitted: Bool
    let autoGradedScore: Int?
    let totalQuestions: Int
    let answeredCount: Int
}

struct ExamResult: Codable, Sendable {
    let examTitle: String
    let score: Double
    let maxScore: Double
    let percentage: Double?
    let grade: String?
    let rank: Int?
    let feedback: String?
    let submittedAt: Date?
    let gradedAt: Date?
    let subjectName: String?
}
