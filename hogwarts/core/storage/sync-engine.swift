import SwiftUI
import SwiftData
import os

/// Sync engine for offline-first architecture.
///
/// Two responsibilities:
///   1. Refresh cross-cutting reference data (students, conversations,
///      notifications) into SwiftData so list views stay snappy and work
///      offline. Per-user data (attendance, grades, timetable) is fetched
///      on-demand by feature view models, which already implement their
///      own offline-first cache reads.
///   2. Replay the offline mutation queue (`PendingAction`) when the
///      network comes back, with exponential backoff and a 3-attempt cap.
///
/// `@MainActor @Observable` so the SyncStatusBanner and any view can read
/// `isSyncing` / `lastSyncCompletedAt` / `lastSyncError` directly without
/// going through `NotificationCenter`.
@MainActor
@Observable
final class SyncEngine {
    static let shared = SyncEngine()

    // MARK: - Observable state (UI binds to these)

    var isSyncing = false
    var lastSyncCompletedAt: Date?
    var lastSyncError: SyncError?

    // MARK: - Dependencies

    private let api: APIClientProtocol
    private let isOnlineCheck: @Sendable () -> Bool
    private let contextProvider: @MainActor () -> ModelContext
    private let logger = Logger.sync

    private var modelContext: ModelContext { contextProvider() }

    /// Only the online-state check, the API, and the model context provider
    /// are injectable. `NetworkMonitor.shared` and `DataContainer.shared` are
    /// used by default so production code stays one-liner-small; tests can
    /// inject an in-memory `ModelContainer` and a constant-bool online flag.
    init(
        api: APIClientProtocol = APIClient.shared,
        isOnline: @escaping @Sendable () -> Bool = { NetworkMonitor.shared.isOnline },
        contextProvider: @escaping @MainActor () -> ModelContext = { DataContainer.shared.modelContext }
    ) {
        self.api = api
        self.isOnlineCheck = isOnline
        self.contextProvider = contextProvider
    }

    // MARK: - Public API

    /// Full sync — runs on app launch, after auth, and on silent push.
    /// Concurrent fan-out via `async let`; errors per entity are captured
    /// in `lastSyncError` but never abort sibling syncs.
    func syncAll() async {
        guard !isSyncing else { return }
        guard isOnlineCheck() else { return }
        guard let context = currentSyncContext() else {
            logger.notice("syncAll skipped — no signed-in user")
            return
        }

        isSyncing = true
        lastSyncError = nil
        defer { isSyncing = false }

        await processPendingActions()

        async let students   = syncStudents(context: context)
        async let convos     = syncConversations(context: context)
        async let notifs     = syncNotifications(context: context)

        let results = await (students, convos, notifs)
        let firstError = [results.0, results.1, results.2].compactMap { $0 }.first
        if let firstError {
            lastSyncError = firstError
            logger.error("Sync completed with errors — first: \(String(describing: firstError))")
        }

        lastSyncCompletedAt = .now
    }

    /// Sync a single entity (e.g. after a write).
    @discardableResult
    func sync(_ entity: SyncableEntity) async -> SyncError? {
        guard isOnlineCheck() else { return .offline }
        guard let context = currentSyncContext() else { return .noUser }

        let error: SyncError? = await {
            switch entity {
            case .students:      return await syncStudents(context: context)
            case .conversations: return await syncConversations(context: context)
            case .notifications: return await syncNotifications(context: context)
            }
        }()
        if let error { lastSyncError = error }
        return error
    }

    /// Queue a write for offline replay. Caller has already encoded the
    /// payload — we never re-encode, so the bytes the server sees are
    /// exactly what the feature action sent.
    ///
    /// Declared `async` so callers' existing `await` remains idiomatic and
    /// so we have room to add real awaits here later (e.g. a write-log
    /// flush) without churning every call site.
    func queueAction(endpoint: String, method: HTTPMethod, payload: Data?) async {
        let action = PendingAction(endpoint: endpoint, method: method, payload: payload)
        modelContext.insert(action)
        try? modelContext.save()

        if isOnlineCheck() {
            Task { await processPendingActions() }
        }
    }

    // MARK: - Pending actions queue

    private func processPendingActions() async {
        let descriptor = FetchDescriptor<PendingAction>(
            predicate: #Predicate {
                $0.status == "pending" || ($0.status == "failed" && $0.retryCount < 3)
            },
            sortBy: [SortDescriptor(\.createdAt)]
        )

        guard let pending = try? modelContext.fetch(descriptor) else { return }

        for action in pending {
            await processAction(action)
        }
    }

    private func processAction(_ action: PendingAction) async {
        if action.retryCount > 0 {
            let delay = pow(2.0, Double(action.retryCount))
            try? await Task.sleep(for: .seconds(delay))
        }

        action.status = SyncStatus.syncing.rawValue
        try? modelContext.save()

        let endpoint = action.endpoint
        let method   = HTTPMethod(rawValue: action.method) ?? .post
        let payload  = action.payload

        do {
            switch method {
            case .post:
                try await api.postRaw(endpoint, jsonBody: payload)
            case .put:
                try await api.putRaw(endpoint, jsonBody: payload)
            case .delete:
                try await api.delete(endpoint)
            case .get, .patch:
                logger.warning("Skipped unsupported queued method \(method.rawValue) for \(endpoint)")
            }
            action.status = SyncStatus.completed.rawValue
            action.errorMessage = nil
        } catch {
            action.retryCount += 1
            if action.retryCount >= 3 {
                action.status = SyncStatus.failed.rawValue
                action.errorMessage = "Max retries exceeded: \(error.localizedDescription)"
                logger.error("Pending action permanently failed: \(endpoint, privacy: .public) \(error.localizedDescription, privacy: .public)")
            } else {
                action.status = SyncStatus.pending.rawValue
                action.errorMessage = error.localizedDescription
            }
        }
        try? modelContext.save()
    }

    // MARK: - Entity sync

    /// Resolve the user we are syncing for. Returns nil if not signed in.
    private func currentSyncContext() -> SyncContext? {
        let descriptor = FetchDescriptor<UserModel>(
            sortBy: [SortDescriptor(\.lastSyncedAt, order: .reverse)]
        )
        guard let user = try? modelContext.fetch(descriptor).first,
              let schoolId = user.schoolId else {
            return nil
        }
        return SyncContext(userId: user.id, schoolId: schoolId)
    }

    /// Refresh the students list. JWT carries `schoolId` server-side,
    /// so we pass no query params except pagination.
    private func syncStudents(context: SyncContext) async -> SyncError? {
        do {
            let response: StudentsResponse = try await api.get(
                "/mobile/students",
                query: ["per_page": "500"],
                as: StudentsResponse.self
            )
            upsertStudents(response.data, schoolId: context.schoolId)
            updateSyncMetadata("students")
            return nil
        } catch {
            logger.error("syncStudents failed: \(error.localizedDescription, privacy: .public)")
            return .entity(.students, error)
        }
    }

    private func syncConversations(context: SyncContext) async -> SyncError? {
        do {
            let response: ConversationsResponse = try await api.get(
                "/mobile/conversations",
                as: ConversationsResponse.self
            )
            upsertConversations(response.data, schoolId: context.schoolId)
            updateSyncMetadata("conversations")
            return nil
        } catch {
            logger.error("syncConversations failed: \(error.localizedDescription, privacy: .public)")
            return .entity(.conversations, error)
        }
    }

    private func syncNotifications(context: SyncContext) async -> SyncError? {
        do {
            let response: NotificationsResponse = try await api.get(
                "/mobile/notifications",
                query: ["per_page": "100"],
                as: NotificationsResponse.self
            )
            upsertNotifications(response.data, schoolId: context.schoolId)
            updateSyncMetadata("notifications")
            return nil
        } catch {
            logger.error("syncNotifications failed: \(error.localizedDescription, privacy: .public)")
            return .entity(.notifications, error)
        }
    }

    // MARK: - SwiftData upserts

    private func upsertStudents(_ students: [Student], schoolId: String) {
        for student in students {
            let id = student.id
            let descriptor = FetchDescriptor<StudentModel>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try? modelContext.fetch(descriptor).first {
                existing.update(from: student)
                existing.lastSyncedAt = .now
            } else {
                let model = StudentModel(from: student, schoolId: schoolId)
                model.lastSyncedAt = .now
                modelContext.insert(model)
            }
        }
        try? modelContext.save()
    }

    private func upsertConversations(_ conversations: [Conversation], schoolId: String) {
        for conv in conversations {
            let id = conv.id
            let descriptor = FetchDescriptor<ConversationModel>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try? modelContext.fetch(descriptor).first {
                existing.name = conv.name
                existing.updatedAt = conv.updatedAt
                existing.lastSyncedAt = .now
            } else {
                let model = ConversationModel(id: conv.id, schoolId: schoolId)
                model.name = conv.name
                model.isGroup = conv.isGroup
                model.lastSyncedAt = .now
                modelContext.insert(model)
            }
        }
        try? modelContext.save()
    }

    private func upsertNotifications(_ notifications: [AppNotification], schoolId: String) {
        for notif in notifications {
            let id = notif.id
            let descriptor = FetchDescriptor<NotificationModel>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try? modelContext.fetch(descriptor).first {
                existing.isRead = notif.isRead
                existing.lastSyncedAt = .now
            } else {
                let model = NotificationModel(
                    id: notif.id,
                    userId: notif.userId,
                    type: notif.type,
                    title: notif.title,
                    message: notif.message,
                    schoolId: schoolId
                )
                model.isRead = notif.isRead
                model.lastSyncedAt = .now
                modelContext.insert(model)
            }
        }
        try? modelContext.save()
    }

    // MARK: - Sync metadata

    private func updateSyncMetadata(_ entityType: String) {
        let descriptor = FetchDescriptor<SyncMetadata>(
            predicate: #Predicate { $0.entityType == entityType }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            existing.lastSyncedAt = .now
            existing.syncVersion += 1
        } else {
            let metadata = SyncMetadata(entityType: entityType)
            metadata.lastSyncedAt = .now
            metadata.syncVersion = 1
            modelContext.insert(metadata)
        }
        try? modelContext.save()
    }
}

// MARK: - Supporting Types

private struct SyncContext {
    let userId: String
    let schoolId: String
}

/// Entities the sync engine knows how to refresh on demand.
enum SyncableEntity: Sendable {
    case students
    case conversations
    case notifications
}

/// Typed error so callers can react (e.g. show retry CTA per entity).
enum SyncError: Error, Sendable, CustomStringConvertible {
    case offline
    case noUser
    case entity(SyncableEntity, Error)

    var description: String {
        switch self {
        case .offline: return "offline"
        case .noUser: return "no-user"
        case .entity(let entity, let error): return "\(entity)-failed: \(error.localizedDescription)"
        }
    }
}

// `Logger.sync` is declared in `core/extensions/logger-extension.swift`.
