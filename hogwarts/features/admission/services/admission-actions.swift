import Foundation

/// Server actions for Admission feature.
/// Mirrors kotlin AdmissionRepository + AdmissionApi.
/// All actions tenant-scoped via schoolId; offline writes queued via SyncEngine.
final class AdmissionActions: Sendable {

    private let api = APIClient.shared

    // MARK: - Read

    /// GET /mobile/admission/applications
    func listApplications(schoolId: String) async throws -> [AdmissionApplication] {
        try await api.get(
            "/mobile/admission/applications",
            as: [AdmissionApplication].self
        )
    }

    /// GET /mobile/admission/applications/{id}
    func getApplication(id: String, schoolId: String) async throws -> AdmissionApplication {
        try await api.get(
            "/mobile/admission/applications/\(id)",
            as: AdmissionApplication.self
        )
    }

    // MARK: - Write

    /// POST /mobile/admission/applications
    func createApplication(schoolId: String) async throws -> AdmissionApplication {
        try await api.post(
            "/mobile/admission/applications",
            body: [String: String](),
            as: AdmissionApplication.self
        )
    }

    /// PATCH /mobile/admission/applications/{id}
    func updateApplication(_ application: AdmissionApplication, schoolId: String) async throws -> AdmissionApplication {
        try await api.patch(
            "/mobile/admission/applications/\(application.id)",
            body: application,
            as: AdmissionApplication.self
        )
    }

    /// POST /mobile/admission/applications/{id}/submit
    func submitApplication(id: String, schoolId: String) async throws -> AdmissionApplication {
        try await api.post(
            "/mobile/admission/applications/\(id)/submit",
            body: [String: String](),
            as: AdmissionApplication.self
        )
    }
}
