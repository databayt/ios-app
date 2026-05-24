import Foundation

enum CourseStatus: String, Codable {
    case draft, published, archived
}

enum LessonType: String, Codable {
    case video, text, quiz
}

enum LessonProgressStatus: String, Codable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case completed
}

struct Course: Codable, Equatable, Identifiable {
    let id: String
    let schoolId: String
    var title: String
    var description: String
    var instructorName: String
    var thumbnailUrl: String?
    var category: String
    var enrollmentCount: Int
    var lessonCount: Int
    var totalDuration: String
    var status: CourseStatus
    var progress: Double
    var grades: [Int]
}

struct StreamLesson: Codable, Equatable, Identifiable {
    let id: String
    let chapterId: String
    var title: String
    var type: LessonType
    var duration: String
    var contentUrl: String?
    var thumbnailUrl: String?
    var orderIndex: Int
    var isCompleted: Bool
    var isLocked: Bool
}

struct Chapter: Codable, Equatable, Identifiable {
    let id: String
    let courseId: String
    var title: String
    var orderIndex: Int
    var lessonCount: Int
    var completedLessons: Int
    var lessons: [StreamLesson]?
}

struct Enrollment: Codable, Equatable, Identifiable {
    let id: String
    let courseId: String
    let userId: String
    var progress: Double
    let startedAt: String
    var lastAccessedAt: String
    var completedAt: String?
}

struct LessonProgress: Codable, Equatable, Identifiable {
    let id: String
    let lessonId: String
    let enrollmentId: String
    var status: LessonProgressStatus
    var score: Int?
    var startedAt: String?
    var completedAt: String?
}

struct StreamQuizQuestion: Codable, Equatable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String?
}

struct CourseCertificate: Codable, Equatable, Identifiable {
    let id: String
    let courseId: String
    let userId: String
    let studentName: String
    let courseName: String
    let completedAt: String
    let certificateUrl: String?
    let verificationCode: String
}
