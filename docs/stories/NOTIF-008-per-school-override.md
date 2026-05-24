# NOTIF-008: Per-school notification override

**Epic**: NOTIF
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** multi-school user
**I want** per-school notification overrides
**So that** I can mute one school without muting another

## Acceptance Criteria

### AC-1: List schools
**Given** I belong to 2+ schools **When** Settings → Notifications **Then** a per-school overrides section appears.

### AC-2: Mute one
**Given** I mute "School B" **When** push from B arrives **Then** silent; School A pushes still alert.

### AC-3: Cross-cutting
**Given** mute mutation **When** sent **Then** scoped to that `school_id`; does not affect other schools' preferences.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested
- [ ] schoolId on every override row
- [ ] Audit logged per school

## Files
- `hogwarts/features/notifications/views/per-school-overrides-view.swift`
- `hogwarts/features/notifications/viewmodels/per-school-viewmodel.swift`
- `hogwarts/features/notifications/services/preferences-actions.swift`

## API Contract
- `GET /api/mobile/notifications/per-school` — `[ { school_id, school_name, lang, muted } ]`
- `PATCH /api/mobile/notifications/per-school/:school_id` — `{ muted }`

## i18n Keys
- `notifications.per_school.title`
- `notifications.per_school.muted`
- `notifications.per_school.empty`

## Tests
- `HogwartsTests/notifications/per-school-tests.swift`
- Multi-school isolation test

## Dependencies
- Depends on: NOTIF-005, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, multi-school isolation verified
