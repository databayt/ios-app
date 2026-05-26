import Foundation

/// Server action for the on-demand translation endpoint.
/// Mirrors web `POST /api/mobile/translate` (hogwarts issue #276).
///
/// Every call goes through `APIClient`, which injects the JWT and
/// scopes the lookup by `schoolId` server-side — so callers do not pass
/// `schoolId` explicitly. The server returns 404 if the entity isn't in
/// the user's school.
final class TranslationActions: Sendable {
    private let api: APIClient

    init(api: APIClient = APIClient.shared) {
        self.api = api
    }

    /// Translate an announcement or assignment to the requested language.
    ///
    /// Returns the source text untouched (with `cached: true`) when the
    /// entity is already in the target language — same shape as the
    /// translated case so callers don't branch.
    func translate(
        _ entity: TranslatableEntity,
        id: String,
        to target: SupportedLanguage
    ) async throws -> TranslateResponse {
        let body = TranslateRequest(
            entityType: entity,
            entityId: id,
            targetLang: target
        )
        return try await api.post(
            "/mobile/translate",
            body: body,
            as: TranslateResponse.self
        )
    }
}
