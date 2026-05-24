# TT-001: Timetable Today View

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student or teacher, I want a Today view showing current and next class, so that I always know what's now and next.

## Acceptance Criteria
### AC-1: Current+next render
**Given** I open Timetable **When** Today is selected **Then** I see current class (highlighted) and next 1-2 classes with countdown to start.

### AC-2: No classes state
**Given** today is a holiday or weekend **When** Today loads **Then** I see "No classes today" with weekday label.

### AC-3: Cross-cutting
Times locale-formatted (12h/24h). Weekday name localized. RTL list. Class names entity.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, teacher)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/timetable/views/timetable-today-view.swift`
- `hogwarts/features/timetable/viewmodels/timetable-viewmodel.swift`
- `hogwarts/features/timetable/services/timetable-service.swift`

## API Contract
- `GET /api/mobile/timetable/:userId?day=today` → `[{ id, period, subject, room, startsAt, endsAt }]`

## i18n Keys
- `common.timetable.today`, `common.timetable.current`, `common.timetable.next`, `common.timetable.empty`

## Tests
- `HogwartsTests/timetable/today-view-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: AUTH-006
- Blocks: TT-002, TT-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
