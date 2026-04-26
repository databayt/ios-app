# PUSH-003: Notification Categories + Actions (Reply, Mark Read, View, Dismiss)

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** Quick Actions (Reply, Mark Read, View, Dismiss) on the lock screen
**So that** I respond without opening the app

## Acceptance Criteria

### AC-1: Categories registered
**Given** the app boots **When** `UNUserNotificationCenter.setNotificationCategories(_:)` is called **Then** categories `MESSAGE`, `ANNOUNCEMENT`, `ATTENDANCE`, `FEE` are registered with localized actions.

### AC-2: Reply text input
**Given** a `MESSAGE` push **When** the user pulls down and taps Reply **Then** a text input appears; sending posts to the conversation via existing message endpoint.

### AC-3: Mark Read
**Given** an `ANNOUNCEMENT` push **When** Mark Read is tapped **Then** `POST /api/mobile/notifications/:id/read` fires.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] schoolId predicate (action API calls tenant-scoped)
- [ ] RTL-tested
- [ ] Audit logged (quick-action invocation)

## Files
- `hogwarts/features/notifications/services/notification-categories.swift`
- `hogwarts/features/notifications/services/notification-action-handler.swift`

## API Contract
- `POST /api/mobile/notifications/:id/read` — live
- Existing `POST /api/mobile/conversations/:id/messages` — for Reply

## i18n Keys
- `notifications.action.reply`, `notifications.action.mark_read`, `notifications.action.view`, `notifications.action.dismiss`

## Tests
- `HogwartsTests/features/notifications/categories-tests.swift` — category registration, action handler dispatch

## Dependencies
- Depends on: PUSH-001
- Blocks: PUSH-004

## Definition of Done
- [ ] AC met, real-device test of Quick Reply, AR + EN screenshots of lock screen
