# MSG-008: Read Receipts

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to see when others have read my messages and have my reads reported
**So that** delivery and visibility are transparent

## Acceptance Criteria

### AC-1: Sent → Delivered → Read
**Given** I send a message **When** it is delivered or read **Then** the bubble shows ticks (1=sent, 2=delivered, 2-blue=read) — RTL flips the tick anchor.

### AC-2: Mark read
**Given** the chat is visible and a message is on screen for >= 1s **When** the lifecycle fires **Then** a read receipt is sent to the server with `school_id`.

### AC-3: Privacy override
**Given** read receipts are disabled in profile settings **When** I read a message **Then** no receipt is sent and my view shows "Delivered" only on outgoing.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate (read receipts include school)
- [ ] Role-gated
- [ ] Audit logged on read

## Files
- `hogwarts/features/messaging/views/message-bubble.swift` — tick icons
- `hogwarts/features/messaging/services/read-receipts-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/:mid/read` — `{ read_at }`

## i18n Keys
- `messaging.read_receipts.delivered`, `messaging.read_receipts.read`

## Tests
- `HogwartsTests/messaging/read-receipts-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: MSG-002, MSG-026
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
