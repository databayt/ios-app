import Foundation

/// Server actions for the Subjects feature.
///
/// All endpoints accept a `lang` query so the backend localizes catalog
/// names, departments, and descriptions before sending — much cheaper than
/// shipping the full multilingual blob and translating client-side.
final class SubjectsActions: Sendable {
    private let api = APIClient.shared

    /// School-adopted catalog subjects.
    func list(
        search: String? = nil,
        department: String? = nil,
        languageCode: String
    ) async throws -> CatalogSubjectsListResponse {
        var query: [String: String] = ["lang": languageCode]
        if let search, !search.isEmpty { query["search"] = search }
        if let department, !department.isEmpty { query["department"] = department }
        return try await api.get(
            "/mobile/subjects",
            query: query,
            as: CatalogSubjectsListResponse.self
        )
    }

    /// Detail with chapters → lessons tree.
    func detail(id: String, languageCode: String) async throws -> CatalogSubjectDetail {
        try await api.get(
            "/mobile/subjects/\(id)",
            query: ["lang": languageCode],
            as: CatalogSubjectDetail.self
        )
    }

    /// Subjects the current user is enrolled in or teaches.
    func mySubjects(languageCode: String) async throws -> MySubjectsResponse {
        try await api.get(
            "/mobile/subjects/my-subjects",
            query: ["lang": languageCode],
            as: MySubjectsResponse.self
        )
    }
}

// MARK: - Locale helper

extension Locale {
    /// Backend `lang` query value — defaults to `"ar"` when the locale
    /// can't be resolved, mirroring the web's default.
    var subjectsApiLanguageCode: String {
        language.languageCode?.identifier ?? identifier.split(separator: "-").first.map(String.init) ?? "ar"
    }
}
