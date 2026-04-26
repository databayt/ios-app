# LOC-010: On-Demand Translation UX (banner + cache)

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user reading content in a foreign language
**I want** a "Translate" affordance like Mail / Safari
**So that** I can read the translated version inline without leaving the screen

## Acceptance Criteria

### AC-1: Affordance shown when langs differ
**Given** `entity.lang != app.currentLanguage` **When** the card renders **Then** a Translate button appears below the card.

### AC-2: Translation appears
**Given** I tap Translate **When** the call completes **Then** the translated body replaces the original (or stacks above) and a "Show original" toggle appears.

### AC-3: Cached
**Given** the same entity is opened later **When** rendered **Then** the cached translation displays instantly without a network round-trip.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] schoolId predicate (entity is tenant-scoped; translation cache key includes schoolId)
- [ ] RTL-tested
- [ ] Audit logged (translate request)

## Files
- `hogwarts/core/translate/translate-service.swift`
- `hogwarts/atoms/hw-translate-button.swift`
- `hogwarts/core/translate/translation-cache.swift`

## API Contract
- `POST /api/mobile/translate` — request `{ entity_type, entity_id, target_lang }`; response `{ translated_text, cached, source_lang }` (NEW endpoint, see backend-gaps P0)

## i18n Keys
- `common.translate.this`, `common.translate.show_original`, `errors.translate.failed`

## Tests
- `HogwartsTests/locale/translate-service-tests.swift` — happy path, cache hit, error fallback

## Dependencies
- Depends on: LOC-009, LOC-012, CORE-007 (feature flag), backend `POST /api/mobile/translate`
- Blocks: none (feature epics consume optionally)

## Definition of Done
- [ ] AC met, behind feature flag until backend ships, snapshot AR app + EN content with translation visible
