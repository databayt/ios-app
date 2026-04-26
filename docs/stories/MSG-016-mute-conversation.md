# MSG-016: Mute Conversation

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to mute conversations to suppress notifications
**So that** noisy chats don't interrupt me

## Acceptance Criteria

### AC-1: Mute toggle
**Given** the user opens conversation info **When** they tap Mute **Then** options appear: 1 hour / 8 hours / 1 day / Always; selecting one persists with `school_id`.

### AC-2: Indicator
**Given** a conversation is muted **When** the row renders in the list **Then** a small bell-with-slash icon appears.

### AC-3: Mention override
**Given** a conversation is muted **When** I am mentioned in it **Then** I still receive a high-priority push (per MSG-010).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/services/mute-service.swift`
- `hogwarts/features/messaging/views/conversation-info-view.swift` — mute UI

## API Contract
- `POST /api/mobile/conversations/:id/mute` — `{ muted_until }`

## i18n Keys
- `messaging.mute`, `messaging.mute.duration_hour`, `messaging.mute.duration_day`, `messaging.mute.always`

## Tests
- `HogwartsTests/messaging/mute-tests.swift`

## Dependencies
- Depends on: MSG-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
