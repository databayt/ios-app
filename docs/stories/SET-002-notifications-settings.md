# SET-002: Notifications Settings

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want per-channel notification toggles plus quiet hours, so that I receive only the alerts I care about.

## Acceptance Criteria
### AC-1: Per-channel toggles
**Given** channels (announcements, attendance, grades, messages, fees, events) **When** I flip a toggle **Then** the preference saves within 500ms and survives logout/login.

### AC-2: Quiet hours
**Given** I set 22:00–07:00 quiet hours **When** the window is active **Then** non-critical pushes suppress; critical (e.g., school emergency) still deliver.

### AC-3: Cross-cutting
Time pickers locale-aware (12h/24h). RTL labels read trailing-leading. Default channel state from server.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`, `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate (preferences are per-school + user)
- [ ] Role-gated (all)
- [ ] Audit logged (preference changes)

## Files
- `hogwarts/features/settings/views/notifications-settings-view.swift`
- `hogwarts/features/settings/viewmodels/notifications-settings-viewmodel.swift`
- `hogwarts/features/settings/services/notification-preferences-service.swift`

## API Contract
- `GET /api/mobile/profile/notification-preferences` → `{ channels: {...}, quietHours: { start, end } }`
- `PUT /api/mobile/profile/notification-preferences`

## i18n Keys
- `notifications.settings.title`, `notifications.channel.<name>`, `notifications.quiet_hours`, `notifications.quiet_hours.start`, `notifications.quiet_hours.end`

## Tests
- `HogwartsTests/settings/notifications-settings-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: SET-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
