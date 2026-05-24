# MSG-009: Typing Indicator

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to see when someone else is typing
**So that** I know to wait for their reply

## Acceptance Criteria

### AC-1: Show typing
**Given** a peer is typing **When** the socket event arrives **Then** an animated three-dot indicator renders below the latest bubble with `<name> is typing` localized; the indicator's text bubble respects the typer's preferred lang/font/direction (per-bubble override of `\.layoutDirection`).

### AC-2: Throttle
**Given** I type **When** keystrokes occur **Then** a typing event emits at most every 3 seconds; clears after 5 seconds of inactivity.

### AC-3: Group chats
**Given** multiple people type at once **When** indicator renders **Then** it shows "X and Y are typing" or "Several are typing" capped at sensible length.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] EACH typing indicator bubble renders in typer's own lang/font/direction (per-bubble override)

## Files
- `hogwarts/features/messaging/views/typing-indicator.swift`
- `hogwarts/features/messaging/services/typing-service.swift`

## API Contract
- Socket.IO event `typing` — `{ user_id, school_id, is_typing }`

## i18n Keys
- `messaging.typing.single`, `messaging.typing.two`, `messaging.typing.many`

## Tests
- `HogwartsTests/messaging/typing-indicator-tests.swift`
- Mixed-lang typer snapshot

## Dependencies
- Depends on: MSG-026
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
