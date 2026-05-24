import Foundation

enum LessonPlanStatus: String, Codable, CaseIterable {
    case draft, published, completed

    var displayName: String {
        switch self {
        case .draft:     String(localized: "lessons.status.draft")
        case .published: String(localized: "lessons.status.published")
        case .completed: String(localized: "lessons.status.completed")
        }
    }
}

enum ActivityType: String, Codable, CaseIterable, Identifiable {
    case lecture, discussion, groupwork, individual, assessment, `break`
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .lecture:    "person.wave.2"
        case .discussion: "bubble.left.and.bubble.right"
        case .groupwork:  "person.3"
        case .individual: "person"
        case .assessment: "checkmark.square"
        case .break:      "cup.and.saucer"
        }
    }
}

enum ResourceType: String, Codable, CaseIterable {
    case pdf, video, link, image, document

    var icon: String {
        switch self {
        case .pdf:      "doc.richtext"
        case .video:    "play.rectangle"
        case .link:     "link"
        case .image:    "photo"
        case .document: "doc"
        }
    }
}

enum TopicStatus: String, Codable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case completed

    var color: String {
        switch self {
        case .notStarted: "gray"
        case .inProgress: "blue"
        case .completed:  "green"
        }
    }
}

struct LessonActivity: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var description: String
    var duration: Int
    var type: ActivityType
}

struct LessonResource: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let type: ResourceType
    let url: String
    let fileSize: Int64?
}

struct LessonPlan: Codable, Equatable, Identifiable {
    let id: String
    let schoolId: String
    let classId: String
    var subjectName: String
    var topic: String
    var date: String
    var objectives: [String] = []
    var activities: [LessonActivity] = []
    var resources: [LessonResource] = []
    var homework: String?
    var teacherNotes: String?
    var status: LessonPlanStatus = .draft
}

struct CurriculumTopic: Codable, Equatable, Identifiable {
    var id: String { "\(weekNumber)-\(title)" }
    let title: String
    let weekNumber: Int
    var status: TopicStatus = .notStarted
}

struct CurriculumSubject: Codable, Equatable, Identifiable {
    var id: String { subjectId }
    let subjectId: String
    let subjectName: String
    var topics: [CurriculumTopic] = []
}

struct CurriculumMap: Codable, Equatable, Identifiable {
    var id: String { termId }
    let termId: String
    let termName: String
    var subjects: [CurriculumSubject] = []
}
