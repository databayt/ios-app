# INTENT-003: Open Messages Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Siri intent to open Messages, so that I can jump to chats from anywhere.

## Acceptance Criteria
### AC-1: Open inbox
**Given** the intent is invoked **When** the app launches **Then** the conversation inbox for current schoolId is shown.

### AC-2: Phrase localization
**Given** Arabic locale **When** user says "افتح الرسائل" **Then** the intent fires.

### AC-3: Auth-gated
**Given** no active session **When** intent runs **Then** app routes to login.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId scope (inbox tenant-scoped)
- [ ] Role-gated

## Files
- `hogwarts/core/intents/open-messages-intent.swift` — AppIntent
- `hogwarts/core/intents/app-shortcuts-provider.swift` — register

## API Contract
None — local routing.

## i18n Keys
- `messaging.intent.open.title`
- `messaging.intent.open.phrase`

## Tests
- `HogwartsTests/intents/open-messages-intent-tests.swift`

## Dependencies
- Depends on: INTENT-001
- Blocks: INTENT-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
