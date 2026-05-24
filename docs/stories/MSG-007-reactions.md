# MSG-007: Message Reactions

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to react to messages with emojis
**So that** I can acknowledge messages without typing

## Acceptance Criteria

### AC-1: Reaction picker
**Given** the user long-presses a bubble **When** the menu appears **Then** a row of common emojis appears + a "More" button to open full picker.

### AC-2: Aggregate display
**Given** multiple users react **When** rendered **Then** the bubble shows aggregated counts grouped by emoji, tap to see who reacted.

### AC-3: Toggle
**Given** the user has already reacted **When** they tap the same emoji **Then** the reaction is removed.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated

## Files
- `hogwarts/features/messaging/views/reaction-picker.swift`
- `hogwarts/features/messaging/services/reactions-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/:mid/reactions` — `{ emoji }` → `{ reactions: [...] }`

## i18n Keys
- `messaging.reactions.more`, `messaging.reactions.who_reacted`

## Tests
- `HogwartsTests/messaging/reactions-tests.swift`

## Dependencies
- Depends on: MSG-002, MSG-021
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
