# MSG-013: Starred Messages

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to star important messages and find them later
**So that** I can bookmark messages for quick reference

## Acceptance Criteria

### AC-1: Star action
**Given** a bubble's context menu is open **When** the user taps Star **Then** a star icon appears on the bubble and the action persists server-side.

### AC-2: Starred list
**Given** the user opens "Starred" from the conversations list filter **When** the screen loads **Then** all starred messages across conversations appear with deep-link to the original chat.

### AC-3: Unstar
**Given** a message is starred **When** the user taps Unstar **Then** the icon is removed and the message no longer appears in the starred list.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Excerpts respect `entity.lang`

## Files
- `hogwarts/features/messaging/views/starred-list-view.swift`
- `hogwarts/features/messaging/services/star-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/:mid/star` — `{ starred: true|false }`
- `GET /api/mobile/messages/starred` — `{ messages: [...] }`

## i18n Keys
- `messaging.star`, `messaging.unstar`, `messaging.starred.title`

## Tests
- `HogwartsTests/messaging/starred-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
