# MSG-026: Socket.IO Real-Time Wire

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** developer of all messaging features
**I want** a single Socket.IO client that delivers real-time events for messages, typing, reactions, read receipts
**So that** UI updates reflect server state within 1 second

## Acceptance Criteria

### AC-1: Connect on auth
**Given** the user signs in **When** auth completes **Then** the socket connects with JWT and `school_id`; reconnect on backgrounding.

### AC-2: Event router
**Given** a `message:new`, `typing`, `reaction`, `read` event arrives **When** processed **Then** it dispatches to the right viewmodel via a typed event router.

### AC-3: Reconnect + backfill
**Given** the socket disconnected for 30s **When** it reconnects **Then** missed messages backfill via REST and the queue drains in order.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `errors`)
- [ ] RTL-tested (reconnect banner)
- [ ] schoolId predicate (server scopes events)
- [ ] Role-gated (server enforces)
- [ ] Audit logged on connect/disconnect

## Files
- `hogwarts/features/messaging/services/socket-client.swift`
- `hogwarts/features/messaging/services/event-router.swift`

## API Contract
- Socket.IO endpoint configurable per env (verify production URL via P1 backend gap)

## i18n Keys
- `messaging.socket.connecting`, `messaging.socket.reconnecting`, `messaging.socket.offline`

## Tests
- `HogwartsTests/messaging/socket-client-tests.swift`
- Reconnect + backfill test

## Dependencies
- Depends on: CORE-001, CORE-002
- Blocks: MSG-003, MSG-008, MSG-009

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
