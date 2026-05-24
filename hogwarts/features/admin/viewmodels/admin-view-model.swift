import Foundation
import SwiftUI

@MainActor
@Observable
final class AdminViewModel {
    private(set) var stats: AdminStats?
    private(set) var school: AdminSchool?
    private(set) var staff: [AdminStaffMember] = []
    private(set) var classes: [AdminClass] = []
    private(set) var isLoading = false
    private(set) var lastError: String?
    var staffFilter: AdminStaffFilter = .all {
        didSet { Task { await reloadStaff() } }
    }

    private let actions: AdminActions

    init(actions: AdminActions = .init()) {
        self.actions = actions
    }

    /// Single load — fan out to stats / school / staff / classes in parallel.
    func loadAll() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        async let statsTask: AdminStats? = {
            do { return try await actions.stats() } catch { return nil }
        }()
        async let schoolTask: AdminSchool? = {
            do { return try await actions.school() } catch { return nil }
        }()
        async let staffTask: AdminStaffResponse? = {
            do { return try await actions.staff(filter: staffFilter, perPage: 30) }
            catch { return nil }
        }()
        async let classesTask: AdminClassesResponse? = {
            do { return try await actions.classes(perPage: 30) } catch { return nil }
        }()

        if let s = await statsTask   { stats = s }
        if let s = await schoolTask  { school = s }
        if let s = await staffTask   { staff = s.data }
        if let c = await classesTask { classes = c.data }
    }

    private func reloadStaff() async {
        do {
            let response = try await actions.staff(filter: staffFilter, perPage: 30)
            staff = response.data
        } catch {
            // Best-effort — keep prior staff visible.
        }
    }
}
