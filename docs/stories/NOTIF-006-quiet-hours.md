# NOTIF-006: Quiet hours

**Epic**: NOTIF
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to define quiet hours (e.g., 22:00–07:00)
**So that** I'm not disturbed during sleep

## Acceptance Criteria

### AC-1: Set window
**Given** Settings → Quiet Hours **When** I pick start/end times **Then** server stores window; APNs payload respects (silent push during window).

### AC-2: Locale time format
**Given** locale `ar-SA` **When** picking time **Then** picker uses 12h Arabic-Indic; locale `en-US` uses 12h Latin (configurable to 24h).

### AC-3: Critical exception
**Given** P0 announcement during quiet hours **When** push arrives **Then** still alerts (overrides quiet).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested time pickers
- [ ] schoolId on mutation
- [ ] Critical-channel override documented
- [ ] Audit logged

## Files
- `hogwarts/features/notifications/views/quiet-hours-view.swift`
- `hogwarts/features/notifications/viewmodels/quiet-hours-viewmodel.swift`
- `hogwarts/features/notifications/services/preferences-actions.swift`

## API Contract
- `PATCH /api/mobile/notifications/preferences` — `{ quiet_hours: { start_minutes, end_minutes, timezone } }`

## i18n Keys
- `notifications.quiet.title`
- `notifications.quiet.start`
- `notifications.quiet.end`
- `notifications.quiet.override_critical`

## Tests
- `HogwartsTests/notifications/quiet-hours-tests.swift`
- Locale 12h/24h test

## Dependencies
- Depends on: NOTIF-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
