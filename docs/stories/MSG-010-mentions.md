# MSG-010: Mentions (@)

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to mention specific people with `@` in a group chat
**So that** they get a personal notification within the group

## Acceptance Criteria

### AC-1: Autocomplete
**Given** the user types `@` **When** the popover appears **Then** a filtered list of conversation members shows; selecting one inserts a mention token.

### AC-2: Render
**Given** a message has mentions **When** rendered **Then** mentions appear as accent-colored tokens; tapping opens the user's profile.

### AC-3: Notification
**Given** I am mentioned in a muted group **When** the message is sent **Then** I still receive a high-priority push because I was mentioned.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate (mention scope)
- [ ] Role-gated
- [ ] Audit logged for mention notifications

## Files
- `hogwarts/features/messaging/views/composer.swift` — mention autocomplete
- `hogwarts/features/messaging/views/message-bubble.swift` — mention render

## API Contract
- `POST /api/mobile/conversations/:id/messages` — `{ body, mentions: [user_id] }`

## i18n Keys
- `messaging.mention.placeholder`

## Tests
- `HogwartsTests/messaging/mentions-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
