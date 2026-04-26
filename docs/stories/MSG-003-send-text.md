# MSG-003: Send Text Message

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to type and send a text message
**So that** I can communicate in real time

## Acceptance Criteria

### AC-1: Send
**Given** the composer has text **When** the user taps Send **Then** the message posts, appears in the chat optimistically with a clock icon, and updates to "delivered" when ack arrives.

### AC-2: Composer language
**Given** the user types **When** they type Arabic in an English app **Then** the composer auto-detects direction per text run, and the saved message stores `body_lang` accordingly.

### AC-3: Failure
**Given** send fails **When** the message stays in optimistic state **Then** an inline retry icon appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] `body_lang` persisted

## Files
- `hogwarts/features/messaging/views/composer.swift`
- `hogwarts/features/messaging/services/send-service.swift`
- `hogwarts/features/messaging/viewmodels/chat-viewmodel.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages` — `{ body, body_lang, idempotency_key }`

## i18n Keys
- `messaging.send`, `messaging.send_failed`, `messaging.retry`

## Tests
- `HogwartsTests/messaging/send-text-tests.swift`

## Dependencies
- Depends on: MSG-002, MSG-027
- Blocks: MSG-026

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
