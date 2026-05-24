import Foundation

/// Server actions for the Contacts directory.
final class ContactsActions: Sendable {
    private let api = APIClient.shared

    /// Fetch all visible contact groups. Backend filters by the caller's
    /// role (teachers see their students, guardians see their children's
    /// teachers, etc.) — the iOS layer never explicitly filters by role.
    func list(search: String? = nil, category: String? = nil, locale: String) async throws -> ContactsResponse {
        var query: [String: String] = ["locale": locale]
        if let search, !search.isEmpty { query["search"] = search }
        if let category, !category.isEmpty { query["category"] = category }
        return try await api.get(
            "/mobile/contacts",
            query: query,
            as: ContactsResponse.self
        )
    }
}
