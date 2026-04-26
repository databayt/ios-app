# TT-003: Timetable Day View

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student or teacher, I want a vertical list of all classes for a chosen day, so that I see details easily on phone.

## Acceptance Criteria
### AC-1: Day list
**Given** I tap a day **When** Day view loads **Then** I see a vertical list of classes, each with period, subject, teacher/room, and status.

### AC-2: Date picker
**Given** I tap the date header **When** the picker opens **Then** I can jump to any date; selecting reloads the list.

### AC-3: Cross-cutting
Times localized. RTL list trailing-leading. Class names entity.lang. Empty state when no classes.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, teacher)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/timetable/views/timetable-day-view.swift`
- `hogwarts/features/timetable/viewmodels/timetable-day-viewmodel.swift`

## API Contract
- `GET /api/mobile/timetable/:userId?day=YYYY-MM-DD` → `[{ ... }]`

## i18n Keys
- `common.timetable.day`, `common.timetable.pick_date`, `common.timetable.empty`

## Tests
- `HogwartsTests/timetable/day-view-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: TT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
