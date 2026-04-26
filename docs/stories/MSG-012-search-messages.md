# MSG-012: Search Messages

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to search for messages by keyword across all my conversations
**So that** I can quickly find past discussions

## Acceptance Criteria

### AC-1: Search bar
**Given** the user opens search **When** they type a query **Then** results stream as they type with conversation context, message excerpt, and timestamp.

### AC-2: Lang-agnostic
**Given** the user searches in Arabic **When** results return **Then** matches in Arabic-language messages are highlighted regardless of app lang.

### AC-3: Empty
**Given** no matches **When** results return **Then** an empty state with hint to try different terms appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (search scoped to school)
- [ ] Role-gated
- [ ] Excerpts in `entity.lang`

## Files
- `hogwarts/features/messaging/views/search-view.swift`
- `hogwarts/features/messaging/viewmodels/search-viewmodel.swift`

## API Contract
- `GET /api/mobile/messages/search?q=...` — `{ results: [{ message_id, conversation_id, excerpt, excerpt_lang }] }`

## i18n Keys
- `messaging.search.placeholder`, `messaging.search.empty`, `messaging.search.results_n`

## Tests
- `HogwartsTests/messaging/search-messages-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
