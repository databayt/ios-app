# NOTIF-003: Mark all notifications read

**Epic**: NOTIF
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to mark all my notifications read at once
**So that** I can clear backlog quickly

## Acceptance Criteria

### AC-1: Bulk mark
**Given** 1+ unread **When** I tap "Mark all read" **Then** all rows mark read; server reflects.

### AC-2: Confirmation
**Given** ≥10 unread **When** I tap **Then** confirm sheet appears.

### AC-3: Cross-cutting
**Given** bulk mutation **When** sent **Then** scoped to current `school_id`; audit logged with count.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested confirm sheet
- [ ] schoolId on mutation
- [ ] Audit logged with count

## Files
- `hogwarts/features/notifications/services/notification-actions.swift` — `markAllRead()`
- `hogwarts/features/notifications/views/notifications-list-view.swift` — toolbar button

## API Contract
- `POST /api/mobile/notifications/read-all` — `{} → { count }`

## i18n Keys
- `notifications.list.mark_all_read`
- `notifications.list.confirm_mark_all`
- `common.confirm`

## Tests
- `HogwartsTests/notifications/mark-all-tests.swift`

## Dependencies
- Depends on: NOTIF-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
