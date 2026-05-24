# MSG-017: Leave Group

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to leave a group conversation
**So that** I no longer receive its messages

## Acceptance Criteria

### AC-1: Leave action
**Given** the user opens conversation info on a group **When** they tap Leave Group **Then** a confirmation alert appears; on confirm, the user is removed and a system message is posted to the group.

### AC-2: 1:1 not allowed
**Given** the conversation is a 1:1 chat **When** the user opens info **Then** Leave Group is hidden.

### AC-3: Last admin guard
**Given** the user is the last admin in the group **When** they tap Leave **Then** an alert blocks the action with a CTA to assign a new admin first.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/services/leave-group-service.swift`
- `hogwarts/features/messaging/views/conversation-info-view.swift`

## API Contract
- `POST /api/mobile/conversations/:id/leave` — `{}` → `{ success }`

## i18n Keys
- `messaging.leave_group`, `messaging.leave_group.confirm`, `messaging.leave_group.last_admin_block`

## Tests
- `HogwartsTests/messaging/leave-group-tests.swift`

## Dependencies
- Depends on: MSG-023
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
