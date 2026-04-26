# MSG-023: Conversation Info (Members, Settings)

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to view conversation metadata, members, and settings
**So that** I can manage notifications and see who is part of the chat

## Acceptance Criteria

### AC-1: Members list
**Given** a group is opened **When** info loads **Then** members list shows avatar, name (in name_lang font), role badge.

### AC-2: Notification settings
**Given** the user is in a conversation **When** they open info **Then** Mute, Pin, Archive controls are present.

### AC-3: Direct chat
**Given** a 1:1 conversation **When** info loads **Then** the peer's profile snippet appears with options to view profile, mute, archive.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Names render in `user.name_lang`

## Files
- `hogwarts/features/messaging/views/conversation-info-view.swift`
- `hogwarts/features/messaging/viewmodels/conversation-info-viewmodel.swift`

## API Contract
- `GET /api/mobile/conversations/:id` — `{ id, kind, name, members: [...], settings: { muted_until, pinned, archived } }`

## i18n Keys
- `messaging.info.title`, `messaging.info.members`, `messaging.info.notifications`

## Tests
- `HogwartsTests/messaging/conversation-info-tests.swift`

## Dependencies
- Depends on: MSG-001
- Blocks: MSG-014, MSG-015, MSG-016, MSG-017, MSG-024

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
