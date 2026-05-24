# MSG-015: Archive Conversation

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to archive conversations I no longer need
**So that** the main list stays focused while I can still access older threads

## Acceptance Criteria

### AC-1: Swipe to archive
**Given** a conversation row **When** the user swipes leading-to-trailing and taps Archive **Then** the row disappears from All and reappears under Archived filter.

### AC-2: Auto-unarchive on new message
**Given** a conversation is archived **When** a new message arrives **Then** it auto-unarchives and reappears in All.

### AC-3: Bulk archive
**Given** the user is in selection mode **When** they tap Archive **Then** all selected conversations archive at once.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested (swipe direction)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/services/archive-service.swift`
- `hogwarts/features/messaging/views/conversations-list-view.swift` — swipe action

## API Contract
- `POST /api/mobile/conversations/:id/archive` — `{ archived: true|false }`

## i18n Keys
- `messaging.archive`, `messaging.unarchive`

## Tests
- `HogwartsTests/messaging/archive-tests.swift`

## Dependencies
- Depends on: MSG-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
