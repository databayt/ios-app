# MSG-014: Pin Message in Conversation

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user (or admin in groups)
**I want** to pin an important message to the top of a conversation
**So that** all participants can see it at a glance

## Acceptance Criteria

### AC-1: Pin action
**Given** the user opens the bubble's context menu **When** they tap Pin **Then** the message anchors to the top banner of the conversation and is broadcast to all participants.

### AC-2: Permission gate
**Given** the conversation is a group **When** a non-admin attempts to pin **Then** the action is hidden or returns 403.

### AC-3: Unpin
**Given** a message is pinned **When** an admin (or 1:1 participant) taps Unpin **Then** the banner disappears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (group-admin in groups, both members in 1:1)
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/views/pinned-banner.swift`
- `hogwarts/features/messaging/services/pin-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/:mid/pin` — `{ pinned: true|false }`

## i18n Keys
- `messaging.pin`, `messaging.unpin`, `messaging.pinned_banner`

## Tests
- `HogwartsTests/messaging/pin-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
