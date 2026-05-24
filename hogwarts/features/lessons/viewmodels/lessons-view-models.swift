import Foundation
import Observation

@MainActor
@Observable
final class LessonPlansViewModel {
    private let actions = LessonsActions()
    var tenantContext: TenantContext?

    var plans: [LessonPlan] = []
    var filterClassId: String?
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        defer { isLoading = false }
        do { plans = try await actions.listLessonPlans(schoolId: schoolId, classId: filterClassId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class LessonDetailViewModel {
    private let actions = LessonsActions()
    var tenantContext: TenantContext?

    var plan: LessonPlan?
    var isLoading = false
    var error: String?

    func load(id: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        defer { isLoading = false }
        do { plan = try await actions.getLessonPlan(id: id, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class LessonPlanFormViewModel {
    private let actions = LessonsActions()
    var tenantContext: TenantContext?

    var plan: LessonPlan
    var isSaving = false
    var error: String?

    init(plan: LessonPlan) { self.plan = plan }

    func save() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isSaving = true
        defer { isSaving = false }
        do { plan = try await actions.saveLessonPlan(plan, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }

    func publish() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        await save()
        do { plan = try await actions.publishLessonPlan(id: plan.id, schoolId: schoolId) }
        catch { self.error = error.localizedDescription }
    }

    func addActivity() {
        plan.activities.append(LessonActivity(description: "", duration: 5, type: .lecture))
    }

    func addObjective() {
        plan.objectives.append("")
    }
}

@MainActor
@Observable
final class CurriculumMapViewModel {
    private let actions = LessonsActions()
    var tenantContext: TenantContext?

    var map: CurriculumMap?
    var termId: String = ""
    var isLoading = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId, !termId.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do { map = try await actions.curriculumMap(schoolId: schoolId, termId: termId) }
        catch { self.error = error.localizedDescription }
    }
}

@MainActor
@Observable
final class ResourceBrowserViewModel {
    private let actions = LessonsActions()
    var tenantContext: TenantContext?

    var resources: [LessonResource] = []
    var filterSubjectId: String?
    var filterType: ResourceType?
    var isLoading = false
    var error: String?

    var filtered: [LessonResource] {
        guard let t = filterType else { return resources }
        return resources.filter { $0.type == t }
    }

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        defer { isLoading = false }
        do { resources = try await actions.listResources(schoolId: schoolId, subjectId: filterSubjectId) }
        catch { self.error = error.localizedDescription }
    }
}
