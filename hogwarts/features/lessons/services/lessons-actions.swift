import Foundation

final class LessonsActions: Sendable {
    private let api = APIClient.shared

    func listLessonPlans(schoolId: String, classId: String? = nil) async throws -> [LessonPlan] {
        var query: [String: String] = [:]
        if let classId { query["classId"] = classId }
        return try await api.get("/mobile/lessons/plans", query: query, as: [LessonPlan].self)
    }

    func getLessonPlan(id: String, schoolId: String) async throws -> LessonPlan {
        try await api.get("/mobile/lessons/plans/\(id)", as: LessonPlan.self)
    }

    func saveLessonPlan(_ plan: LessonPlan, schoolId: String) async throws -> LessonPlan {
        try await api.patch("/mobile/lessons/plans/\(plan.id)", body: plan, as: LessonPlan.self)
    }

    func publishLessonPlan(id: String, schoolId: String) async throws -> LessonPlan {
        try await api.post("/mobile/lessons/plans/\(id)/publish", body: [String: String](), as: LessonPlan.self)
    }

    func curriculumMap(schoolId: String, termId: String) async throws -> CurriculumMap {
        try await api.get("/mobile/lessons/curriculum/\(termId)", as: CurriculumMap.self)
    }

    func listResources(schoolId: String, subjectId: String? = nil) async throws -> [LessonResource] {
        var query: [String: String] = [:]
        if let subjectId { query["subjectId"] = subjectId }
        return try await api.get("/mobile/lessons/resources", query: query, as: [LessonResource].self)
    }
}
