# LOC-001: String Catalog Reorg into 20 Namespaces

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** localization-conscious team
**I want** `Localizable.xcstrings` reorganized into 20 namespaces matching the web dictionaries
**So that** strings are discoverable, parity is enforceable, and translators see the same buckets across web + mobile

## Acceptance Criteria

### AC-1: 20 namespaces present
**Given** the catalog **When** opened **Then** keys are grouped under: `admin`, `attendance`, `auth`, `banking`, `common`, `errors`, `finance`, `generate`, `home`, `lab`, `library`, `marking`, `messages`, `messaging`, `notifications`, `onboarding`, `profile`, `results`, `sales`, `transportation`, `whatsapp` (matching `i18n.md`).

### AC-2: Migration script
**Given** existing keys without namespace **When** `scripts/migrate-strings.sh` runs **Then** every key is rewritten to `<namespace>.<rest>` with no key collisions.

### AC-3: All sources updated
**Given** the codebase **When** rebuilt **Then** every `String(localized:)` and `Text("...")` call site references the new namespaced key.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `all`)
- [ ] EN + AR pairs both present after migration

## Files
- `hogwarts/Resources/Localizable.xcstrings` — namespaced keys
- `scripts/migrate-strings.sh` — migration tool

## API Contract
- None.

## i18n Keys
- All existing keys reorganized.

## Tests
- `HogwartsTests/locale/string-catalog-tests.swift` — every namespace has both `en` and `ar` localizations

## Dependencies
- Depends on: none
- Blocks: LOC-002, every feature epic

## Definition of Done
- [ ] AC met, build green, no orphaned keys, parity ≥99%
