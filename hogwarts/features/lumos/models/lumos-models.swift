import Foundation

// Wire models for the Lumos LMS block.
//
// Truth: `/api/mobile/lumos/*` (hogwarts `src/app/api/mobile/lumos/`), ported
// from the Android DTOs (`feature/lumos/.../data/remote/dto/*.kt`). `APIClient`
// decodes with default keys, so every key is explicit and every field is
// lenient: a missing or malformed field becomes its default instead of taking
// the whole screen down.

// MARK: - Courses page (`GET /mobile/lumos/courses`)

struct LumosCoursesPage: Decodable, Sendable, Equatable {
    var shelves: [GradeShelf] = []
    var continueWatching: [ResumeLesson] = []
    var recommendedGrade: Int?
    var effectiveGrade: Int?
    var startHere: StartHereLesson?
    var search: CourseSearch = CourseSearch()

    enum CodingKeys: String, CodingKey {
        case shelves, search
        case continueWatching = "continue_watching"
        case recommendedGrade = "recommended_grade"
        case effectiveGrade = "effective_grade"
        case startHere = "start_here"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        shelves = c.lenientArray(.shelves)
        continueWatching = c.lenientArray(.continueWatching)
        recommendedGrade = c.lenient(.recommendedGrade)
        effectiveGrade = c.lenient(.effectiveGrade)
        startHere = c.lenient(.startHere)
        search = c.lenient(.search, CourseSearch())
    }

    init() {}
}

struct GradeShelf: Decodable, Sendable, Equatable, Identifiable {
    var grade: Int = 0
    var courses: [CatalogCourse] = []

    var id: Int { grade }

    enum CodingKeys: String, CodingKey { case grade, courses }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        grade = c.lenient(.grade, 0)
        courses = c.lenientArray(.courses)
    }
}

struct CatalogCourse: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var slug: String = ""
    var title: String = ""
    var imageUrl: String?
    var color: String?
    var grades: [Int] = []
    var chapters: Int = 0
    var enrollments: Int = 0
    var totalLessons: Int = 0
    var averageRating: Double = 0
    var levels: [String] = []
    var category: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, title, color, grades, chapters, enrollments, levels, category
        case imageUrl = "image_url"
        case totalLessons = "total_lessons"
        case averageRating = "average_rating"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        slug = c.lenient(.slug, "")
        title = c.lenient(.title, "")
        imageUrl = c.lenient(.imageUrl)
        color = c.lenient(.color)
        grades = c.lenientArray(.grades)
        chapters = c.lenient(.chapters, 0)
        enrollments = c.lenient(.enrollments, 0)
        totalLessons = c.lenient(.totalLessons, 0)
        averageRating = c.lenient(.averageRating, 0)
        levels = c.lenientArray(.levels)
        category = c.lenient(.category)
    }
}

struct CourseSearch: Decodable, Sendable, Equatable {
    var query: String = ""
    var courses: [CatalogCourse] = []
    var total: Int = 0
    var page: Int = 1
    var perPage: Int = 12

    enum CodingKeys: String, CodingKey {
        case query, courses, total, page
        case perPage = "per_page"
    }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        query = c.lenient(.query, "")
        courses = c.lenientArray(.courses)
        total = c.lenient(.total, 0)
        page = c.lenient(.page, 1)
        perPage = c.lenient(.perPage, 12)
    }
}

struct LessonInstructor: Decodable, Sendable, Equatable {
    var name: String?
    var image: String?

    enum CodingKeys: String, CodingKey { case name, image }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = c.lenient(.name)
        image = c.lenient(.image)
    }
}

struct ResumeLesson: Decodable, Sendable, Equatable, Identifiable {
    var lessonId: String = ""
    var lessonTitle: String = ""
    var chapterTitle: String = ""
    var courseTitle: String = ""
    var courseSlug: String = ""
    var thumbnailUrl: String?
    var color: String?
    var grade: Int?
    var watchedSeconds: Int = 0
    var totalSeconds: Int = 0
    var instructor: LessonInstructor?

    var id: String { lessonId }

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return min(1, Double(watchedSeconds) / Double(totalSeconds))
    }

    enum CodingKeys: String, CodingKey {
        case color, grade, instructor
        case lessonId = "lesson_id"
        case lessonTitle = "lesson_title"
        case chapterTitle = "chapter_title"
        case courseTitle = "course_title"
        case courseSlug = "course_slug"
        case thumbnailUrl = "thumbnail_url"
        case watchedSeconds = "watched_seconds"
        case totalSeconds = "total_seconds"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        lessonId = c.lenient(.lessonId, "")
        lessonTitle = c.lenient(.lessonTitle, "")
        chapterTitle = c.lenient(.chapterTitle, "")
        courseTitle = c.lenient(.courseTitle, "")
        courseSlug = c.lenient(.courseSlug, "")
        thumbnailUrl = c.lenient(.thumbnailUrl)
        color = c.lenient(.color)
        grade = c.lenient(.grade)
        watchedSeconds = c.lenient(.watchedSeconds, 0)
        totalSeconds = c.lenient(.totalSeconds, 0)
        instructor = c.lenient(.instructor)
    }
}

struct StartHereLesson: Decodable, Sendable, Equatable, Identifiable {
    var lessonId: String = ""
    var lessonTitle: String = ""
    var chapterTitle: String = ""
    var courseId: String = ""
    var courseTitle: String = ""
    var courseSlug: String = ""
    var thumbnailUrl: String?
    var color: String?
    var grade: Int?
    var totalLessons: Int = 0
    var instructor: LessonInstructor?

    var id: String { lessonId }

    enum CodingKeys: String, CodingKey {
        case color, grade, instructor
        case lessonId = "lesson_id"
        case lessonTitle = "lesson_title"
        case chapterTitle = "chapter_title"
        case courseId = "course_id"
        case courseTitle = "course_title"
        case courseSlug = "course_slug"
        case thumbnailUrl = "thumbnail_url"
        case totalLessons = "total_lessons"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        lessonId = c.lenient(.lessonId, "")
        lessonTitle = c.lenient(.lessonTitle, "")
        chapterTitle = c.lenient(.chapterTitle, "")
        courseId = c.lenient(.courseId, "")
        courseTitle = c.lenient(.courseTitle, "")
        courseSlug = c.lenient(.courseSlug, "")
        thumbnailUrl = c.lenient(.thumbnailUrl)
        color = c.lenient(.color)
        grade = c.lenient(.grade)
        totalLessons = c.lenient(.totalLessons, 0)
        instructor = c.lenient(.instructor)
    }
}

// MARK: - Course page (`GET /mobile/lumos/courses/{slug}`)

struct CoursePage: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var slug: String = ""
    var title: String = ""
    var description: String?
    var objectives: [String] = []
    var prerequisites: String?
    var targetAudience: String?
    var imageUrl: String?
    var color: String?
    var quizCount: Int = 0
    var schoolName: String?
    var price: Double?
    var currency: String?
    var isEnrolled: Bool = false
    var progress: CourseProgress?
    var chapters: [CoursePageChapter] = []
    var labels: [String: String] = [:]

    var isFree: Bool { price == nil || price == 0 }
    var totalLessons: Int { chapters.reduce(0) { $0 + $1.lessons.count } }
    var totalMinutes: Int { chapters.reduce(0) { $0 + $1.lessons.reduce(0) { $0 + ($1.duration ?? 0) } } }

    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, objectives, prerequisites, color, price, currency, progress, chapters, labels
        case targetAudience = "target_audience"
        case imageUrl = "image_url"
        case quizCount = "quiz_count"
        case schoolName = "school_name"
        case isEnrolled = "is_enrolled"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        slug = c.lenient(.slug, "")
        title = c.lenient(.title, "")
        description = c.lenient(.description)
        objectives = c.lenientArray(.objectives)
        prerequisites = c.lenient(.prerequisites)
        targetAudience = c.lenient(.targetAudience)
        imageUrl = c.lenient(.imageUrl)
        color = c.lenient(.color)
        quizCount = c.lenient(.quizCount, 0)
        schoolName = c.lenient(.schoolName)
        price = c.lenient(.price)
        currency = c.lenient(.currency)
        isEnrolled = c.lenient(.isEnrolled, false)
        progress = c.lenient(.progress)
        chapters = c.lenientArray(.chapters)
        labels = c.lenientLabels(.labels)
    }
}

struct CourseProgress: Decodable, Sendable, Equatable {
    var totalLessons: Int = 0
    var completedLessons: Int = 0
    var percent: Int = 0
    var remainingMinutes: Int = 0

    enum CodingKeys: String, CodingKey {
        case percent
        case totalLessons = "total_lessons"
        case completedLessons = "completed_lessons"
        case remainingMinutes = "remaining_minutes"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        totalLessons = c.lenient(.totalLessons, 0)
        completedLessons = c.lenient(.completedLessons, 0)
        percent = c.lenient(.percent, 0)
        remainingMinutes = c.lenient(.remainingMinutes, 0)
    }
}

struct CoursePageChapter: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""
    var lessons: [CoursePageLesson] = []

    enum CodingKeys: String, CodingKey { case id, title, lessons }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
        lessons = c.lenientArray(.lessons)
    }
}

struct CoursePageLesson: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""
    var duration: Int?
    var imageUrl: String?
    var isFree: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, duration
        case imageUrl = "image_url"
        case isFree = "is_free"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
        duration = c.lenient(.duration)
        imageUrl = c.lenient(.imageUrl)
        isFree = c.lenient(.isFree, false)
    }
}

// MARK: - Lesson page (`GET /mobile/lumos/lessons/{id}`)

struct LessonPage: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""
    var description: String?
    var thumbnailUrl: String?
    var color: String?
    var isFree: Bool = false
    var duration: Int?
    var videoDuration: Int?
    var course: LessonCourseRef = LessonCourseRef()
    var chapter: LessonChapterRef = LessonChapterRef()
    var position: Int = 1
    var meta: String = ""
    var blurb: String = ""
    var playLabel: String = ""
    var videoUrl: String?
    var isFallbackVideo: Bool = false
    var instructors: Int = 0
    var progress: LessonProgressRef?
    var previous: LessonLink?
    var next: LessonLink?
    var siblings: [SiblingLesson] = []
    var resources: [LumosLessonResource] = []
    var quiz: [LessonQuizQuestion] = []
    var labels: [String: String] = [:]

    enum CodingKeys: String, CodingKey {
        case id, title, description, color, course, chapter, position, meta, blurb, instructors, progress,
             previous, next, siblings, resources, quiz, labels, duration
        case thumbnailUrl = "thumbnail_url"
        case isFree = "is_free"
        case videoDuration = "video_duration"
        case playLabel = "play_label"
        case videoUrl = "video_url"
        case isFallbackVideo = "is_fallback_video"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
        description = c.lenient(.description)
        thumbnailUrl = c.lenient(.thumbnailUrl)
        color = c.lenient(.color)
        isFree = c.lenient(.isFree, false)
        duration = c.lenient(.duration)
        videoDuration = c.lenient(.videoDuration)
        course = c.lenient(.course, LessonCourseRef())
        chapter = c.lenient(.chapter, LessonChapterRef())
        position = c.lenient(.position, 1)
        meta = c.lenient(.meta, "")
        blurb = c.lenient(.blurb, "")
        playLabel = c.lenient(.playLabel, "")
        videoUrl = c.lenient(.videoUrl)
        isFallbackVideo = c.lenient(.isFallbackVideo, false)
        instructors = c.lenient(.instructors, 0)
        progress = c.lenient(.progress)
        previous = c.lenient(.previous)
        next = c.lenient(.next)
        siblings = c.lenientArray(.siblings)
        resources = c.lenientArray(.resources)
        quiz = c.lenientArray(.quiz)
        labels = c.lenientLabels(.labels)
    }
}

struct LessonCourseRef: Decodable, Sendable, Equatable {
    var id: String = ""
    var slug: String = ""
    var title: String = ""

    enum CodingKeys: String, CodingKey { case id, slug, title }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        slug = c.lenient(.slug, "")
        title = c.lenient(.title, "")
    }
}

struct LessonChapterRef: Decodable, Sendable, Equatable {
    var title: String = ""
    var position: Int = 1

    enum CodingKeys: String, CodingKey { case title, position }

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        title = c.lenient(.title, "")
        position = c.lenient(.position, 1)
    }
}

struct LessonLink: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""

    enum CodingKeys: String, CodingKey { case id, title }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
    }
}

struct LessonProgressRef: Decodable, Sendable, Equatable {
    var isCompleted: Bool = false
    var watchedSeconds: Int = 0
    var totalSeconds: Int?

    enum CodingKeys: String, CodingKey {
        case isCompleted = "is_completed"
        case watchedSeconds = "watched_seconds"
        case totalSeconds = "total_seconds"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        isCompleted = c.lenient(.isCompleted, false)
        watchedSeconds = c.lenient(.watchedSeconds, 0)
        totalSeconds = c.lenient(.totalSeconds)
    }
}

struct SiblingLesson: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""
    var thumbnailUrl: String?
    var color: String?
    var duration: Int?
    var lessonPosition: Int = 1
    var chapterPosition: Int = 1
    var watchedMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, color, duration
        case thumbnailUrl = "thumbnail_url"
        case lessonPosition = "lesson_position"
        case chapterPosition = "chapter_position"
        case watchedMinutes = "watched_minutes"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
        thumbnailUrl = c.lenient(.thumbnailUrl)
        color = c.lenient(.color)
        duration = c.lenient(.duration)
        lessonPosition = c.lenient(.lessonPosition, 1)
        chapterPosition = c.lenient(.chapterPosition, 1)
        watchedMinutes = c.lenient(.watchedMinutes)
    }
}

struct LumosLessonResource: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var title: String = ""
    var description: String?
    var url: String?

    enum CodingKeys: String, CodingKey { case id, title, description, url }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        title = c.lenient(.title, "")
        description = c.lenient(.description)
        url = c.lenient(.url)
    }
}

/// An answer-key-free question; `choices == nil` is a free-text answer.
struct LessonQuizQuestion: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var text: String = ""
    var type: String = ""
    var choices: [String]?

    enum CodingKeys: String, CodingKey { case id, text, type, choices }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        text = c.lenient(.text, "")
        type = c.lenient(.type, "")
        choices = c.lenient(.choices)
    }
}

// MARK: - Quiz grade (`POST /mobile/courses/{courseId}/lessons/{lessonId}/quiz`)

struct QuizGrade: Decodable, Sendable, Equatable {
    var score: Int = 0
    var totalQuestions: Int = 0
    var percentage: Int = 0
    var passed: Bool = false
    var syncedToGradebook: Bool = false
    var verdicts: [QuizVerdict] = []

    enum CodingKeys: String, CodingKey {
        case score, percentage, passed, verdicts
        case totalQuestions = "total_questions"
        case syncedToGradebook = "synced_to_gradebook"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        score = c.lenient(.score, 0)
        totalQuestions = c.lenient(.totalQuestions, 0)
        percentage = c.lenient(.percentage, 0)
        passed = c.lenient(.passed, false)
        syncedToGradebook = c.lenient(.syncedToGradebook, false)
        verdicts = c.lenientArray(.verdicts)
    }
}

struct QuizVerdict: Decodable, Sendable, Equatable, Identifiable {
    var questionId: String = ""
    var isCorrect: Bool = false
    var correctIndex: Int?
    var correctAnswers: [String]?
    var explanation: String?
    var sampleAnswer: String?

    var id: String { questionId }

    enum CodingKeys: String, CodingKey {
        case explanation
        case questionId = "question_id"
        case isCorrect = "is_correct"
        case correctIndex = "correct_index"
        case correctAnswers = "correct_answers"
        case sampleAnswer = "sample_answer"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        questionId = c.lenient(.questionId, "")
        isCorrect = c.lenient(.isCorrect, false)
        correctIndex = c.lenient(.correctIndex)
        correctAnswers = c.lenient(.correctAnswers)
        explanation = c.lenient(.explanation)
        sampleAnswer = c.lenient(.sampleAnswer)
    }
}

// MARK: - Certificate (`GET /mobile/courses/{courseId}/certificate`)

struct LumosCertificate: Decodable, Sendable, Equatable, Identifiable {
    var id: String = ""
    var courseId: String = ""
    var userId: String = ""
    var studentName: String = ""
    var courseName: String = ""
    var completedAt: String = ""
    var certificateUrl: String?
    var verificationCode: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course_id"
        case userId = "user_id"
        case studentName = "student_name"
        case courseName = "course_name"
        case completedAt = "completed_at"
        case certificateUrl = "certificate_url"
        case verificationCode = "verification_code"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = c.lenient(.id, "")
        courseId = c.lenient(.courseId, "")
        userId = c.lenient(.userId, "")
        studentName = c.lenient(.studentName, "")
        courseName = c.lenient(.courseName, "")
        completedAt = c.lenient(.completedAt, "")
        certificateUrl = c.lenient(.certificateUrl)
        verificationCode = c.lenient(.verificationCode, "")
    }
}

// MARK: - Decoding helpers

extension KeyedDecodingContainer {
    /// A labels map that drops null values (the API sends `null` for untranslated words).
    func lenientLabels(_ key: Key) -> [String: String] {
        let raw: [String: String?] = lenient(key, [:])
        return raw.compactMapValues { $0 }
    }
}
