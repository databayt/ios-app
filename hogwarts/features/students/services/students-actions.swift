import Foundation

/// Server actions for Students feature
/// Mirrors: src/components/platform/students/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class StudentsActions: Sendable {

    private let api: APIClientProtocol
    private let syncEngine = SyncEngine.shared

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    // MARK: - Read Actions

    /// Get students with filters and pagination
    /// Web API: GET /mobile/students?search=X&section_id=Y&status=Z&page=N&per_page=N
    func getStudents(
        schoolId: String,
        filters: StudentFilters = StudentFilters()
    ) async throws -> StudentsResponse {
        let params = filters.queryParams

        return try await api.get("/mobile/students", query: params, as: StudentsResponse.self)
    }

    /// Get single student by ID
    /// Web API: GET /mobile/students/{studentId}
    func getStudent(id: String, schoolId: String) async throws -> Student {
        return try await api.get("/mobile/students/\(id)", as: Student.self)
    }

    /// Search students (uses the same list endpoint with search param)
    /// Web API: GET /mobile/students?search=X&per_page=N
    func searchStudents(
        query: String,
        schoolId: String,
        limit: Int = 10
    ) async throws -> [Student] {
        let params = [
            "search": query,
            "per_page": String(limit)
        ]

        let response = try await api.get("/mobile/students", query: params, as: StudentsResponse.self)
        return response.data
    }

    // MARK: - Write Actions

    /// Create new student
    /// Web API: POST /mobile/students
    /// Body: {given_name, family_name, email, gender, section_id, date_of_birth}
    func createStudent(
        _ request: StudentCreateRequest,
        schoolId: String
    ) async throws -> Student {
        // Validate input
        let validation = StudentsValidation.validateCreateForm(
            grNumber: request.grNumber,
            givenName: request.givenName,
            surname: request.surname,
            email: request.email,
            phone: request.phone,
            dateOfBirth: request.dateOfBirth
        )

        guard validation.isValid else {
            throw StudentsError.validationFailed(validation.errors)
        }

        return try await api.post("/mobile/students", body: request, as: Student.self)
    }

    /// Update student (partial update)
    /// Web API: PUT /mobile/students/{studentId}
    func updateStudent(
        id: String,
        _ request: StudentUpdateRequest,
        schoolId: String
    ) async throws -> Student {
        // Validate input
        let validation = StudentsValidation.validateUpdateForm(
            givenName: request.givenName,
            surname: request.surname,
            email: request.email,
            phone: request.phone,
            dateOfBirth: request.dateOfBirth
        )

        guard validation.isValid else {
            throw StudentsError.validationFailed(validation.errors)
        }

        return try await api.put("/mobile/students/\(id)", body: request, as: Student.self)
    }

    // NOTE: DELETE /mobile/students/{id} does not exist in the web API.
    // Student deletion is an admin-only web operation.

    // MARK: - Offline Actions

    /// Create student (offline-capable)
    /// Queues action if offline
    @MainActor
    func createStudentOffline(
        _ request: StudentCreateRequest,
        schoolId: String
    ) async throws -> Student? {
        if NetworkMonitor.shared.isConnected {
            return try await createStudent(request, schoolId: schoolId)
        }

        // Queue for later
        let payload = try JSONEncoder().encode(request)
        await syncEngine.queueAction(
            endpoint: "/mobile/students",
            method: .post,
            payload: payload
        )

        return nil
    }

    /// Update student (offline-capable)
    @MainActor
    func updateStudentOffline(
        id: String,
        _ request: StudentUpdateRequest,
        schoolId: String
    ) async throws -> Student? {
        if NetworkMonitor.shared.isConnected {
            return try await updateStudent(id: id, request, schoolId: schoolId)
        }

        let payload = try JSONEncoder().encode(request)
        await syncEngine.queueAction(
            endpoint: "/mobile/students/\(id)",
            method: .put,
            payload: payload
        )

        return nil
    }

    // NOTE: deleteStudent removed — DELETE /mobile/students/{id} does not
    // exist in the web mobile API.
}

// MARK: - Errors

enum StudentsError: LocalizedError {
    case validationFailed([String: String])
    case notFound
    case unauthorized
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return errors.values.joined(separator: ", ")
        case .notFound:
            return String(localized: "student.error.notFound")
        case .unauthorized:
            return String(localized: "error.unauthorized")
        case .serverError(let message):
            return message
        }
    }
}
