import Foundation
import Testing
@testable import Hogwarts

/// Decodes payloads shaped like production's `/api/mobile/lumos/*`, the way
/// `APIClient` would (default keys, ISO-8601 dates).
@Suite("Lumos DTOs")
struct LumosModelsTests {
    private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(type, from: Data(json.utf8))
    }

    @Test("courses page reads shelves, resume rows and the lead lesson")
    func coursesPage() throws {
        let json = """
        {
          "shelves": [
            {"grade": 7, "courses": [
              {"id":"c1","slug":"algebra","title":"Algebra","image_url":"https://cdn/x.png",
               "color":"#3B82F6","grades":[7,8],"chapters":4,"enrollments":12,
               "total_lessons":20,"average_rating":4.5,"levels":["beginner"],"category":"maths"}
            ]}
          ],
          "continue_watching": [
            {"lesson_id":"l9","lesson_title":"Fractions","chapter_title":"Chapter 2",
             "course_title":"Algebra","course_slug":"algebra","thumbnail_url":"https://cdn/y.png",
             "color":"#111111","grade":7,"watched_seconds":300,"total_seconds":600,
             "instructor":{"name":"Sample Teacher","image":null}}
          ],
          "recommended_grade": 7,
          "effective_grade": 7,
          "start_here": {"lesson_id":"l1","lesson_title":"Intro","chapter_title":"Chapter 1",
                         "course_id":"c1","course_title":"Algebra","course_slug":"algebra",
                         "thumbnail_url":null,"color":null,"grade":7,"total_lessons":20,
                         "instructor":{"name":null,"image":null}},
          "search": {"query":"","courses":[],"total":0,"page":1,"per_page":12}
        }
        """
        let page = try decode(LumosCoursesPage.self, json)
        #expect(page.shelves.count == 1)
        #expect(page.shelves[0].grade == 7)
        #expect(page.shelves[0].courses.first?.slug == "algebra")
        #expect(page.shelves[0].courses.first?.totalLessons == 20)
        #expect(page.continueWatching.first?.progress == 0.5)
        #expect(page.continueWatching.first?.instructor?.name == "Sample Teacher")
        #expect(page.effectiveGrade == 7 && page.recommendedGrade == 7)
        #expect(page.startHere?.courseSlug == "algebra")
        #expect(page.search.perPage == 12)
    }

    @Test("a missing shelf field falls back instead of failing the page")
    func lenientPage() throws {
        let page = try decode(LumosCoursesPage.self, #"{"shelves":[],"continue_watching":null}"#)
        #expect(page.shelves.isEmpty)
        #expect(page.continueWatching.isEmpty)
        #expect(page.recommendedGrade == nil)
        #expect(page.search.perPage == 12)
    }

    @Test("course page carries chapters, progress and the page's words")
    func coursePage() throws {
        let json = """
        {
          "id":"c1","slug":"algebra","title":"Algebra","description":"Numbers",
          "objectives":["Add","Subtract"],"prerequisites":"None","target_audience":"Grade 7",
          "image_url":null,"color":"#3B82F6","quiz_count":2,"school_name":"Sample School",
          "price":null,"currency":null,"is_enrolled":true,
          "progress":{"total_lessons":2,"completed_lessons":1,"percent":50,"remaining_minutes":30},
          "chapters":[{"id":"ch1","title":"Chapter 1","lessons":[
            {"id":"l1","title":"Intro","duration":12,"image_url":null,"is_free":true}
          ]}],
          "labels":{"more":"More","free":"Free","missing":null}
        }
        """
        let page = try decode(CoursePage.self, json)
        #expect(page.isFree)
        #expect(page.totalLessons == 1)
        #expect(page.totalMinutes == 12)
        #expect(page.progress?.percent == 50)
        #expect(page.chapters.first?.lessons.first?.isFree == true)
        // A null label is dropped, not carried as an empty string.
        #expect(page.labels["missing"] == nil)
        #expect(page.labels["more"] == "More")
    }

    @Test("lesson page keeps the quiz, the siblings and the labels")
    func lessonPage() throws {
        let json = """
        {
          "id":"l1","title":"Intro","description":"Start here","thumbnail_url":null,
          "color":null,"is_free":true,"duration":12,"video_duration":700,
          "course":{"id":"c1","slug":"algebra","title":"Algebra"},
          "chapter":{"title":"Chapter 1","position":1},"position":2,
          "meta":"Grade 7 · 12 min","blurb":"Algebra · Chapter 1 Start here",
          "play_label":"Play C1, L2","video_url":"/api/lumos/video/v1","is_fallback_video":false,
          "instructors":1,
          "progress":{"is_completed":false,"watched_seconds":30,"total_seconds":700},
          "previous":{"id":"l0","title":"Before"},
          "next":null,
          "siblings":[{"id":"l3","title":"Next one","thumbnail_url":null,"color":null,
                       "duration":10,"lesson_position":3,"chapter_position":1,"watched_minutes":4}],
          "resources":[{"id":"r1","title":"Worksheet","description":null,"url":"/api/lumos/file/pdf/r1"}],
          "quiz":[{"id":"q1","text":"2 + 2?","type":"MULTIPLE_CHOICE","choices":["3","4"]},
                  {"id":"q2","text":"Explain","type":"SHORT_ANSWER","choices":null}],
          "labels":{"quiz":"Quiz","quiz_submit":"Submit"}
        }
        """
        let page = try decode(LessonPage.self, json)
        #expect(page.course.slug == "algebra")
        #expect(page.chapter.position == 1)
        #expect(page.videoUrl == "/api/lumos/video/v1")
        #expect(!page.isFallbackVideo)
        #expect(page.previous?.id == "l0")
        #expect(page.next == nil)
        #expect(page.siblings.first?.watchedMinutes == 4)
        #expect(page.resources.first?.url == "/api/lumos/file/pdf/r1")
        #expect(page.quiz.count == 2)
        #expect(page.quiz[0].choices == ["3", "4"])
        #expect(page.quiz[1].choices == nil)
        #expect(page.labels["quiz_submit"] == "Submit")
    }

    @Test("quiz grade reads the verdicts")
    func quizGrade() throws {
        let json = """
        {"score":1,"total_questions":2,"percentage":50,"passed":true,
         "synced_to_gradebook":true,
         "verdicts":[{"question_id":"q1","is_correct":true,"correct_index":1,
                      "correct_answers":null,"explanation":"Two plus two","sample_answer":null}]}
        """
        let grade = try decode(QuizGrade.self, json)
        #expect(grade.score == 1 && grade.totalQuestions == 2)
        #expect(grade.passed && grade.syncedToGradebook)
        #expect(grade.verdicts.first?.correctIndex == 1)
        #expect(grade.verdicts.first?.isCorrect == true)
    }

    @Test("a quiz answer encodes as an index or as text, never as an object")
    func quizAnswerEncoding() throws {
        let submission = ["q1": QuizAnswer.index(1), "q2": QuizAnswer.text("four")]
        let data = try JSONEncoder().encode(submission)
        let object = try #require(
            JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        #expect(object["q1"] as? Int == 1)
        #expect(object["q2"] as? String == "four")
    }

    @Test("certificate reads the school's numbers")
    func certificate() throws {
        let json = """
        {"id":"cert1","course_id":"c1","user_id":"u1","student_name":"A Student",
         "course_name":"Algebra","completed_at":"2026-09-01T10:00:00.000Z",
         "certificate_url":null,"verification_code":"LUMOS-0001"}
        """
        let certificate = try decode(LumosCertificate.self, json)
        #expect(certificate.studentName == "A Student")
        #expect(certificate.verificationCode == "LUMOS-0001")
        #expect(certificate.certificateUrl == nil)
    }
}
