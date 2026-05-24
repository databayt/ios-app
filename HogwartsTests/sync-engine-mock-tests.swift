import Foundation
import SwiftData
import Testing
@testable import Hogwarts

/// End-to-end tests for the rewritten `SyncEngine`, wired through the
/// `APIClientProtocol` seam and an in-memory `ModelContainer`.
/// These prove:
///   - The engine hits the correct `/mobile/*` paths
///   - Errors from any single entity surface via `lastSyncError` but
///     never abort the sibling syncs
///   - The offline short-circuit skips all network work
///   - The pending-action queue replays raw bytes via `postRaw` / `putRaw`
@Suite("SyncEngine (protocol seam)")
@MainActor
struct SyncEngineMockTests {

    // MARK: - Online short-circuit

    @Test("syncAll bails out when offline and sets no state")
    func offlineShortCircuit() async {
        let api = MockAPIClient()
        let engine = makeEngine(api: api, online: false)
        await engine.syncAll()
        #expect(!engine.isSyncing)
        #expect(engine.lastSyncCompletedAt == nil)
        #expect(engine.lastSyncError == nil)
        #expect(api.calls.isEmpty)
    }

    @Test("syncAll without a signed-in user does not hit the network")
    func noUserShortCircuit() async {
        let api = MockAPIClient()
        let engine = makeEngine(api: api, online: true, users: []) // empty
        await engine.syncAll()
        #expect(api.calls.isEmpty)
    }

    // MARK: - Endpoint correctness

    @Test("syncAll hits /mobile/students, /mobile/conversations, /mobile/notifications")
    func hitsMobilePaths() async {
        let api = MockAPIClient()
        api.stubEmpty(for: "/mobile/students")
        api.stubEmpty(for: "/mobile/conversations")
        api.stubEmpty(for: "/mobile/notifications")

        let engine = makeEngine(api: api, online: true)
        await engine.syncAll()

        let paths = api.calls.map(\.path).sorted()
        #expect(paths == [
            "/mobile/conversations",
            "/mobile/notifications",
            "/mobile/students"
        ])
        #expect(engine.lastSyncError == nil)
        #expect(engine.lastSyncCompletedAt != nil)
    }

    @Test("schoolId is never passed as a query param — JWT carries it")
    func noSchoolIdQuery() async {
        let api = MockAPIClient()
        api.stubEmpty(for: "/mobile/students")
        api.stubEmpty(for: "/mobile/conversations")
        api.stubEmpty(for: "/mobile/notifications")

        let engine = makeEngine(api: api, online: true)
        await engine.syncAll()

        for call in api.calls {
            #expect(call.query["schoolId"] == nil)
        }
    }

    // MARK: - Error isolation

    @Test("One entity failing does not abort the siblings")
    func errorIsolation() async {
        let api = MockAPIClient()
        api.stubFailure(for: "/mobile/students", error: URLError(.timedOut))
        api.stubEmpty(for: "/mobile/conversations")
        api.stubEmpty(for: "/mobile/notifications")

        let engine = makeEngine(api: api, online: true)
        await engine.syncAll()

        #expect(api.calls.count == 3, "all three entities should have been attempted")
        #expect(engine.lastSyncError != nil, "the error should surface")
        if case .entity(let entity, _) = engine.lastSyncError {
            #expect(entity == .students || entity == .conversations || entity == .notifications)
        } else {
            Issue.record("expected .entity error, got \(String(describing: engine.lastSyncError))")
        }
    }

    // MARK: - Pending action replay

    @Test("queueAction replays queued POSTs through postRaw verbatim")
    func queueActionReplaysPost() async {
        let api = MockAPIClient()
        api.stubRawSuccess(for: "/mobile/attendance/mark")
        let engine = makeEngine(api: api, online: true)

        let payload = try? JSONEncoder().encode(["student_id": "abc123"])
        await engine.queueAction(
            endpoint: "/mobile/attendance/mark",
            method: .post,
            payload: payload
        )

        // Process kicked off as a detached Task inside queueAction; yield
        // enough to let it complete before asserting.
        try? await Task.sleep(for: .milliseconds(50))

        let raws = api.rawCalls
        #expect(raws.contains(where: { $0.path == "/mobile/attendance/mark" && $0.method == .post }))
        #expect(raws.first?.body == payload,
                "queued bytes must be replayed verbatim — no re-encode")
    }

    // MARK: - Helpers

    private func makeEngine(
        api: MockAPIClient,
        online: Bool,
        users: [UserModel]? = nil
    ) -> SyncEngine {
        let container = inMemoryContainer()
        let ctx = container.mainContext
        let seedUsers: [UserModel] = users ?? [UserModel.fixture()]
        for user in seedUsers {
            ctx.insert(user)
        }
        try? ctx.save()

        return SyncEngine(
            api: api,
            isOnline: { online },
            contextProvider: { ctx }
        )
    }

    private func inMemoryContainer() -> ModelContainer {
        let schema = Schema(versionedSchema: HogwartsSchemaV1.self)
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
            allowsSave: true
        )
        return try! ModelContainer(for: schema, configurations: config)
    }
}

// MARK: - Mock API client

/// Records every call so tests can assert on paths, query, body; returns
/// the stub the test installed for a given path. Thread-safe via actor.
final class MockAPIClient: APIClientProtocol, @unchecked Sendable {

    struct Call: Sendable {
        let path: String
        let method: HTTPMethod
        let query: [String: String]
    }
    struct RawCall: Sendable {
        let path: String
        let method: HTTPMethod
        let body: Data?
    }

    private let lock = NSLock()
    private var _calls: [Call] = []
    private var _rawCalls: [RawCall] = []
    private var stubs: [String: (Data) -> Result<Data, Error>] = [:]
    private var rawSuccess: Set<String> = []

    var calls: [Call] { lock.withLock { _calls } }
    var rawCalls: [RawCall] { lock.withLock { _rawCalls } }

    // MARK: Stubs

    func stubEmpty(for path: String) {
        stubs[path] = { _ in
            // JSON that decodes to any of our "list" responses as an empty page.
            .success(Data(#"{"data":[],"total":0,"page":1,"per_page":20}"#.utf8))
        }
    }

    func stubFailure(for path: String, error: Error) {
        stubs[path] = { _ in .failure(error) }
    }

    /// Install a success response with custom JSON bytes. Used by the
    /// AuthManager tests to return a real `User` from `/mobile/profile`.
    func installSuccess(for path: String, payload: Data) {
        stubs[path] = { _ in .success(payload) }
    }

    func stubRawSuccess(for path: String) {
        rawSuccess.insert(path)
    }

    // MARK: APIClientProtocol

    func get<T: Decodable & Sendable>(_ path: String, as type: T.Type) async throws -> T {
        try await getCommon(path, method: .get, query: [:])
    }
    func get<T: Decodable & Sendable>(_ path: String, query: [String: String], as type: T.Type) async throws -> T {
        try await getCommon(path, method: .get, query: query)
    }
    func post<T: Decodable & Sendable, B: Encodable & Sendable>(_ path: String, body: B, as type: T.Type) async throws -> T {
        try await getCommon(path, method: .post, query: [:])
    }
    func put<T: Decodable & Sendable, B: Encodable & Sendable>(_ path: String, body: B, as type: T.Type) async throws -> T {
        try await getCommon(path, method: .put, query: [:])
    }
    func postRaw(_ path: String, jsonBody: Data?) async throws {
        lock.withLock {
            _rawCalls.append(RawCall(path: path, method: .post, body: jsonBody))
        }
        guard rawSuccess.contains(path) else { throw URLError(.badServerResponse) }
    }
    func putRaw(_ path: String, jsonBody: Data?) async throws {
        lock.withLock {
            _rawCalls.append(RawCall(path: path, method: .put, body: jsonBody))
        }
        guard rawSuccess.contains(path) else { throw URLError(.badServerResponse) }
    }
    func delete(_ path: String) async throws {
        lock.withLock {
            _calls.append(Call(path: path, method: .delete, query: [:]))
        }
    }
    func setOnUnauthorized(_ handler: @escaping @Sendable () async -> Void) async {}
    func setAuthorizationProvider(_ provider: @escaping @Sendable () -> String?) async {}

    // MARK: Internals

    private func getCommon<T: Decodable>(_ path: String, method: HTTPMethod, query: [String: String]) async throws -> T {
        lock.withLock {
            _calls.append(Call(path: path, method: method, query: query))
        }
        guard let stub = stubs[path] else {
            throw URLError(.fileDoesNotExist)
        }
        switch stub(Data()) {
        case .success(let data):
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Fixtures

private extension UserModel {
    static func fixture(
        id: String = "user-1",
        schoolId: String = "school-1"
    ) -> UserModel {
        let u = UserModel(
            id: id,
            email: "demo@kingfahad.edu",
            name: "Demo User",
            role: .student,
            schoolId: schoolId
        )
        u.lastSyncedAt = .now
        return u
    }
}
