import Foundation

/// Server actions for Attendance feature
/// Mirrors: src/components/platform/attendance/actions.ts
///
/// CRITICAL: All actions must include schoolId for multi-tenant isolation
final class AttendanceActions: Sendable {

    private let api: APIClientProtocol
    private let syncEngine = SyncEngine.shared

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    // MARK: - Read Actions

    /// Get attendance for a specific class on a date
    /// Web API: GET /mobile/attendance/class/{classId}?date=YYYY-MM-DD
    func getClassAttendance(
        classId: String,
        date: Date,
        schoolId: String
    ) async throws -> [Attendance] {
        let formatter = ISO8601DateFormatter()
        let params: [String: String] = [
            "date": formatter.string(from: date)
        ]

        return try await api.get(
            "/mobile/attendance/class/\(classId)",
            query: params,
            as: [Attendance].self
        )
    }

    /// Get attendance history for a specific student (paginated)
    /// Web API: GET /mobile/attendance/student/{studentId}?from=X&to=Y&page=N&per_page=N
    func getStudentAttendance(
        studentId: String,
        schoolId: String,
        from: Date? = nil,
        to: Date? = nil,
        page: Int = 1,
        perPage: Int = 20
    ) async throws -> AttendanceResponse {
        var params: [String: String] = [
            "page": String(page),
            "per_page": String(perPage)
        ]

        let formatter = ISO8601DateFormatter()
        if let from = from {
            params["from"] = formatter.string(from: from)
        }
        if let to = to {
            params["to"] = formatter.string(from: to)
        }

        return try await api.get(
            "/mobile/attendance/student/\(studentId)",
            query: params,
            as: AttendanceResponse.self
        )
    }

    /// Get attendance summary/statistics for a student
    /// Web API: GET /mobile/attendance/summary/{studentId}
    /// Returns: {total, present, absent, late, excused, percentage}
    func getStats(
        studentId: String,
        schoolId: String
    ) async throws -> AttendanceStats {
        return try await api.get(
            "/mobile/attendance/summary/\(studentId)",
            as: AttendanceStats.self
        )
    }

    /// Get students in a class
    func getClassStudents(
        classId: String,
        schoolId: String
    ) async throws -> [StudentInfo] {
        return try await api.get(
            "/mobile/teacher/classes/\(classId)/students",
            query: ["schoolId": schoolId],
            as: [StudentInfo].self
        )
    }

    /// Get classes assigned to the current teacher
    func getTeacherClasses(schoolId: String) async throws -> [TeacherClassItem] {
        return try await api.get(
            "/mobile/teacher/classes",
            query: ["schoolId": schoolId],
            as: [TeacherClassItem].self
        )
    }

    // MARK: - Write Actions

    /// Mark attendance for a single student
    /// Web API: POST /mobile/attendance/mark
    /// Body: {student_id, section_id?, date?, status, notes?, method?}
    /// Returns: {id, student_id, date, status}
    func markAttendance(
        _ request: AttendanceMarkRequest,
        schoolId: String
    ) async throws -> Attendance {
        // Validate input
        let validation = AttendanceValidation.validateMarkForm(
            studentId: request.studentId,
            date: request.date,
            status: AttendanceStatus(rawValue: request.status),
            notes: request.notes
        )

        guard validation.isValid else {
            throw AttendanceError.validationFailed(validation.errors)
        }

        return try await api.post("/mobile/attendance/mark", body: request, as: Attendance.self)
    }

    /// Bulk mark attendance for a class
    /// Web API: POST /mobile/attendance/bulk
    /// Body: {records: [{student_id, status, notes?}], section_id?, date?}
    func bulkMarkAttendance(
        _ request: AttendanceBulkMarkRequest,
        schoolId: String
    ) async throws -> [Attendance] {
        return try await api.post("/mobile/attendance/bulk", body: request, as: [Attendance].self)
    }

    // NOTE: QR check-in, QR sessions, excuse management, individual record
    // update/delete, and getAttendanceRecord do not exist in the web mobile API.
    // These features may be added in future API versions.

    // MARK: - Offline Actions

    /// Mark attendance (offline-capable)
    /// Queues action if offline
    @MainActor
    func markAttendanceOffline(
        _ request: AttendanceMarkRequest,
        schoolId: String
    ) async throws -> Attendance? {
        if NetworkMonitor.shared.isConnected {
            return try await markAttendance(request, schoolId: schoolId)
        }

        // Queue for later
        let payload = try JSONEncoder().encode(request)
        await syncEngine.queueAction(
            endpoint: "/mobile/attendance/mark",
            method: .post,
            payload: payload
        )

        return nil
    }

    /// Bulk mark attendance (offline-capable)
    @MainActor
    func bulkMarkAttendanceOffline(
        _ request: AttendanceBulkMarkRequest,
        schoolId: String
    ) async throws -> [Attendance]? {
        if NetworkMonitor.shared.isConnected {
            return try await bulkMarkAttendance(request, schoolId: schoolId)
        }

        // Queue for later
        let payload = try JSONEncoder().encode(request)
        await syncEngine.queueAction(
            endpoint: "/mobile/attendance/bulk",
            method: .post,
            payload: payload
        )

        return nil
    }
}

// MARK: - Errors

enum AttendanceError: LocalizedError {
    case validationFailed([String: String])
    case notFound
    case unauthorized
    case qrExpired
    case qrInvalid
    case alreadyMarked
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return errors.values.joined(separator: ", ")
        case .notFound:
            return String(localized: "attendance.error.notFound")
        case .unauthorized:
            return String(localized: "error.unauthorized")
        case .qrExpired:
            return String(localized: "attendance.error.qrExpired")
        case .qrInvalid:
            return String(localized: "attendance.error.qrInvalid")
        case .alreadyMarked:
            return String(localized: "attendance.error.alreadyMarked")
        case .serverError(let message):
            return message
        }
    }
}
