# LOC-011: Composer Language Picker

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher]
**Multi-Tenant**: required

## User Story
**As an** admin or teacher composing announcements / messages / assignments
**I want** to pick the content language explicitly
**So that** the recipient's app can render the entity correctly and offer translation

## Acceptance Criteria

### AC-1: Picker present
**Given** any composer (announcement, message, assignment) **When** rendered **Then** a language picker (segmented control) appears with `العربية` / `English`, defaulting to current app language.

### AC-2: Stored on record
**Given** I submit **When** the request fires **Then** the payload contains `lang: "ar" | "en"`.

### AC-3: Mismatch warning
**Given** I type Arabic in the body but lang is set to `en` **When** about to submit **Then** a soft warning prompts to confirm.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `messages`, `messaging`)
- [ ] schoolId predicate (record tenant-scoped)
- [ ] RTL-tested
- [ ] Audit logged (composer submission)

## Files
- `hogwarts/atoms/forms/hw-content-lang-picker.swift`
- Composer views in `features/announcements`, `features/messaging`, `features/marking` (consume picker)

## API Contract
- Consumed by existing announcement/message/assignment POST endpoints; verify each accepts `lang` field.

## i18n Keys
- `common.compose.language`, `common.compose.lang_mismatch_warning`

## Tests
- `HogwartsTests/locale/composer-lang-picker-tests.swift` — default, override, mismatch warning

## Dependencies
- Depends on: LOC-009, DSGN-007
- Blocks: announcement / messaging / marking feature epics

## Definition of Done
- [ ] AC met, snapshot AR + EN composer, lang field present in submitted payloads (verified via mock)
