# MSG-011: Reply Threads

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to reply to a specific message and start a thread
**So that** side conversations stay attached to context

## Acceptance Criteria

### AC-1: Reply gesture
**Given** the user swipes a bubble **When** the swipe completes **Then** the composer attaches a "Replying to" preview of the original message.

### AC-2: Thread render
**Given** a message has replies **When** rendered **Then** the bubble shows reply count and tapping expands the thread inline.

### AC-3: Cancel reply
**Given** a reply is composed but not sent **When** the user taps the X **Then** the reply context is cleared.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested (swipe direction mirrors)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Reply preview respects `entity.lang`

## Files
- `hogwarts/features/messaging/views/composer.swift` — reply context
- `hogwarts/features/messaging/views/thread-view.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages` — `{ body, reply_to: message_id }`

## i18n Keys
- `messaging.reply.replying_to`, `messaging.reply.replies_n`

## Tests
- `HogwartsTests/messaging/reply-threads-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
