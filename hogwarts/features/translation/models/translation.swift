import Foundation

// MARK: - DTOs
//
// Mirrors web `POST /api/mobile/translate` route added in hogwarts PR for
// issue #276. APIClient already applies `.convertFromSnakeCase`, so the
// Swift fields stay camelCase while the wire stays snake_case.
//
// Whitelist matches the server side (v1 supports `announcement` +
// `assignment`; `message` is deferred until the Message model gets a
// `lang` column).

enum TranslatableEntity: String, Codable, Sendable, CaseIterable {
    case announcement
    case assignment
}

enum SupportedLanguage: String, Codable, Sendable, CaseIterable {
    case ar
    case en
}

/// Request body for `POST /api/mobile/translate`.
struct TranslateRequest: Encodable, Sendable, Equatable {
    let entityType: TranslatableEntity
    let entityId: String
    let targetLang: SupportedLanguage

    enum CodingKeys: String, CodingKey {
        case entityType = "entity_type"
        case entityId = "entity_id"
        case targetLang = "target_lang"
    }
}

/// Response from `POST /api/mobile/translate`.
///
/// `cached: true` means the server returned a value from `TranslationCache`
/// rather than calling Google Translate. The client can use this as a
/// hint for analytics — a sustained drop in hit-rate signals cache
/// thrashing (e.g., announcement bodies churning faster than they're
/// re-rendered).
struct TranslateResponse: Decodable, Sendable, Equatable {
    let translatedText: String
    let cached: Bool
    let sourceLang: SupportedLanguage

    enum CodingKeys: String, CodingKey {
        case translatedText = "translated_text"
        case cached
        case sourceLang = "source_lang"
    }
}
