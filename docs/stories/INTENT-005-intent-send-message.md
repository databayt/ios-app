# INTENT-005: Send Message Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Siri intent "Send message to <contact>: <body>", so that I can send chats hands-free.

## Acceptance Criteria
### AC-1: Contact parameter
**Given** the intent runs **When** the contact param is requested **Then** an EntityQuery returns the user's school directory (tenant-scoped).

### AC-2: Body and confirm
**Given** a contact + body **When** Siri confirms **Then** the message is posted to the conversation, optimistic update displayed, idempotency key included.

### AC-3: Cross-tenant guard
**Given** the user has multiple schools **When** the intent payload includes schoolId **Then** server rejects mismatched school.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId scope (payload + server)
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/core/intents/send-message-intent.swift` — AppIntent
- `hogwarts/core/intents/contact-entity.swift` — AppEntity
- `hogwarts/features/messaging/services/message-service.swift` — used

## API Contract
- `POST /api/mobile/messages` — `{ schoolId, conversationId, body, idempotencyKey }`

## i18n Keys
- `messaging.intent.send.title`
- `messaging.intent.send.parameter.contact`
- `messaging.intent.send.parameter.body`
- `messaging.intent.send.confirm`

## Tests
- `HogwartsTests/intents/send-message-intent-tests.swift`

## Dependencies
- Depends on: INTENT-003
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
