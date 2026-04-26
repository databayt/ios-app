# NOTIF-002: Mark single notification read

**Epic**: NOTIF
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to mark a notification read
**So that** I can clear my unread count

## Acceptance Criteria

### AC-1: Tap → read
**Given** unread row **When** I tap or swipe-mark-read **Then** server marks read; row updates instantly (optimistic).

### AC-2: Offline
**Given** offline **When** I mark read **Then** queued; retried on reconnect; UI stays consistent.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** request includes `school_id` header; audit logged server-side.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL unaffected (state)
- [ ] schoolId on mutation
- [ ] Audit logged

## Files
- `hogwarts/features/notifications/services/notification-actions.swift` — `markRead(id)`
- `hogwarts/features/notifications/viewmodels/notifications-viewmodel.swift`

## API Contract
- `POST /api/mobile/notifications/:id/read` — `{} → { id, read_at }`

## i18n Keys
- `notifications.row.action.mark_read`

## Tests
- `HogwartsTests/notifications/mark-read-tests.swift`
- Offline-queue test

## Dependencies
- Depends on: NOTIF-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, schoolId scope verified
