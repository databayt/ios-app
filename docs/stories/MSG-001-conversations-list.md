# MSG-001: Conversations List (with Mute/Archive/Pin Filters)

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user (any role)
**I want** to see all conversations with filters for All / Pinned / Muted / Archived
**So that** I can quickly find or hide conversations

## Acceptance Criteria

### AC-1: Filter chips
**Given** the user opens Messages **When** the screen loads **Then** chips for All, Pinned, Muted, Archived appear; tapping reorders/filters the list.

### AC-2: Row content
**Given** conversations exist **When** rendered **Then** each row shows avatar, title, last message preview (in author lang), unread badge, timestamp.

### AC-3: Empty state per filter
**Given** the user taps Archived but has no archived conversations **When** filtered **Then** an empty state appears specific to the filter.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Last message preview respects `entity.lang`

## Files
- `hogwarts/features/messaging/views/conversations-list-view.swift`
- `hogwarts/features/messaging/viewmodels/conversations-list-viewmodel.swift`
- `hogwarts/features/messaging/models/conversation.swift`

## API Contract
- `GET /api/mobile/conversations?filter=all|pinned|muted|archived` — `{ conversations: [...] }`

## i18n Keys
- `messaging.list.title`, `messaging.filter.all`, `messaging.filter.pinned`, `messaging.filter.muted`, `messaging.filter.archived`

## Tests
- `HogwartsTests/messaging/conversations-list-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: CORE-001
- Blocks: MSG-002, MSG-014, MSG-015, MSG-016

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
