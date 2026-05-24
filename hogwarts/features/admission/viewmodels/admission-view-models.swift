import Foundation
import Observation

@MainActor
@Observable
final class ApplicationsViewModel {
    private let actions = AdmissionActions()
    var tenantContext: TenantContext?

    var applications: [AdmissionApplication] = []
    var isLoading: Bool = false
    var error: String?

    func load() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        error = nil
        do {
            applications = try await actions.listApplications(schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func refresh() async { await load() }

    func createNew() async -> AdmissionApplication? {
        guard let schoolId = tenantContext?.currentSchoolId else { return nil }
        do {
            let new = try await actions.createApplication(schoolId: schoolId)
            applications.insert(new, at: 0)
            return new
        } catch {
            self.error = error.localizedDescription
            return nil
        }
    }
}

@MainActor
@Observable
final class ApplicationFormViewModel {
    private let actions = AdmissionActions()
    var tenantContext: TenantContext?

    var application: AdmissionApplication
    var isSaving: Bool = false
    var error: String?

    init(application: AdmissionApplication) {
        self.application = application
    }

    var currentStep: ApplicationStep {
        get { application.currentStep }
        set { application.currentStep = newValue }
    }

    var progress: Double {
        Double(currentStep.rawValue) / Double(ApplicationStep.allCases.count)
    }

    func goToNext() {
        if let next = ApplicationStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
        }
    }

    func goToPrevious() {
        if let prev = ApplicationStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prev
        }
    }

    func save() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isSaving = true
        error = nil
        do {
            application = try await actions.updateApplication(application, schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
        isSaving = false
    }

    func submit() async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        await save()
        do {
            application = try await actions.submitApplication(id: application.id, schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
    }
}

@MainActor
@Observable
final class ApplicationStatusViewModel {
    private let actions = AdmissionActions()
    var tenantContext: TenantContext?

    var application: AdmissionApplication?
    var isLoading: Bool = false
    var error: String?

    func load(id: String) async {
        guard let schoolId = tenantContext?.currentSchoolId else { return }
        isLoading = true
        error = nil
        do {
            application = try await actions.getApplication(id: id, schoolId: schoolId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
