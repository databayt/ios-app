# MSG-027: Offline Send Queue with Retry

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** messages I send offline to queue and deliver when I'm back online
**So that** poor connectivity never costs me my words

## Acceptance Criteria

### AC-1: Queue on offline
**Given** the device is offline **When** the user sends a message **Then** it persists in a local SwiftData queue with `school_id`, `user_id`, idempotency key; the bubble shows a clock icon.

### AC-2: Drain in order
**Given** the device reconnects **When** the queue drains **Then** messages POST in original send order, and each updates from queued → sent → delivered.

### AC-3: Failure handling
**Given** the queue retries 3 times and fails **When** the next attempt errors **Then** the bubble surfaces a retry icon; tapping retries manually.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate (queue keyed by school)
- [ ] Role-gated
- [ ] Audit logged on final send

## Files
- `hogwarts/features/messaging/services/send-queue-service.swift`
- `hogwarts/features/messaging/models/queued-message.swift`

## API Contract
- Reuses `POST /api/mobile/conversations/:id/messages` with idempotency key

## i18n Keys
- `messaging.queue.queued`, `messaging.queue.retry`, `messaging.queue.failed`

## Tests
- `HogwartsTests/messaging/offline-queue-tests.swift`
- Reconnect order test

## Dependencies
- Depends on: MSG-026
- Blocks: MSG-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
