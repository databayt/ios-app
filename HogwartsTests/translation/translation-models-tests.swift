import Foundation
import Testing
@testable import Hogwarts

/// Tests for the translation DTOs. Locks the wire contract so a future
/// rename can't silently break the iOS ↔ web boundary.
@Suite("Translation DTOs")
struct TranslationModelsTests {

    // MARK: - TranslateRequest

    @Test("TranslateRequest encodes with snake_case keys")
    func requestEncodesSnakeCase() throws {
        let req = TranslateRequest(
            entityType: .announcement,
            entityId: "ann-1",
            targetLang: .en
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(req)
        let json = String(data: data, encoding: .utf8)
        #expect(
            json == #"{"entity_id":"ann-1","entity_type":"announcement","target_lang":"en"}"#
        )
    }

    @Test("TranslateRequest assignment + ar encodes correctly")
    func requestAssignmentArabic() throws {
        let req = TranslateRequest(
            entityType: .assignment,
            entityId: "asg-9",
            targetLang: .ar
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(req)
        let json = String(data: data, encoding: .utf8)
        #expect(
            json == #"{"entity_id":"asg-9","entity_type":"assignment","target_lang":"ar"}"#
        )
    }

    // MARK: - TranslateResponse

    @Test("TranslateResponse decodes snake_case from the web payload")
    func responseDecodesSnakeCase() throws {
        let json = #"""
        {
          "translated_text": "Hello",
          "cached": true,
          "source_lang": "ar"
        }
        """#
        let res = try JSONDecoder().decode(
            TranslateResponse.self,
            from: Data(json.utf8)
        )
        #expect(res.translatedText == "Hello")
        #expect(res.cached == true)
        #expect(res.sourceLang == .ar)
    }

    @Test("TranslateResponse round-trips empty translated_text (server returns 200 for empty source)")
    func responseEmptyText() throws {
        let json = #"""
        {
          "translated_text": "",
          "cached": true,
          "source_lang": "en"
        }
        """#
        let res = try JSONDecoder().decode(
            TranslateResponse.self,
            from: Data(json.utf8)
        )
        #expect(res.translatedText == "")
        #expect(res.cached == true)
    }

    @Test("TranslateResponse fails to decode when a required field is missing")
    func responseRequiresAllFields() {
        // Drop source_lang — decoder should throw rather than silently
        // pass nil through.
        let json = #"""
        {
          "translated_text": "Hello",
          "cached": false
        }
        """#
        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode(
                TranslateResponse.self,
                from: Data(json.utf8)
            )
        }
    }

    // MARK: - Enums

    @Test("TranslatableEntity raw values match the server whitelist")
    func entityRawValues() {
        #expect(TranslatableEntity.announcement.rawValue == "announcement")
        #expect(TranslatableEntity.assignment.rawValue == "assignment")
        // CaseIterable lets the iOS UI render every supported entity
        // without listing them twice. If the server adds a new entity,
        // adding it here is a one-line change.
        #expect(TranslatableEntity.allCases.count == 2)
    }

    @Test("SupportedLanguage covers ar + en only — matches the server's enum")
    func languageRawValues() {
        #expect(SupportedLanguage.ar.rawValue == "ar")
        #expect(SupportedLanguage.en.rawValue == "en")
        #expect(SupportedLanguage.allCases.count == 2)
    }
}
