# INTENT-006: Mark Notifications Read Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Siri/Shortcuts intent to mark all notifications read, so that I can clear the badge in one tap.

## Acceptance Criteria
### AC-1: Run intent
**Given** unread notifications exist **When** intent runs **Then** all notifications for current schoolId are marked read; badge count drops to zero.

### AC-2: No notifications
**Given** zero unread **When** intent runs **Then** Siri responds "All caught up".

### AC-3: Tenant scope
**Given** user belongs to multiple schools **When** intent runs **Then** only current TenantContext school's notifications are affected.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested
- [ ] schoolId scope (request payload)
- [ ] Role-gated (own notifications only)
- [ ] Audit logged

## Files
- `hogwarts/core/intents/mark-notifications-read-intent.swift` — AppIntent
- `hogwarts/features/notifications/services/notifications-service.swift` — bulk mark

## API Contract
- `POST /api/mobile/notifications/read-all` — `{ schoolId }`, returns `{ updated }`

## i18n Keys
- `notifications.intent.markAllRead.title`
- `notifications.intent.markAllRead.empty`
- `notifications.intent.markAllRead.success`

## Tests
- `HogwartsTests/intents/mark-notifications-read-tests.swift`

## Dependencies
- Depends on: INTENT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
