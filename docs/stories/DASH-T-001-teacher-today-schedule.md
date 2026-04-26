# DASH-T-001: Teacher Today Schedule

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want today's schedule on the dashboard, so that I know my next class without opening Timetable.

## Acceptance Criteria
### AC-1: List today's classes
**Given** dashboard loads **When** the section renders **Then** I see today's classes (period, subject, class name, room) in chronological order; current class highlighted.

### AC-2: Tap goes to class detail
**Given** I tap a class row **When** navigation runs **Then** I land on the class detail (TT-004).

### AC-3: Cross-cutting
Times locale-formatted (12h/24h). RTL list. Class/subject names in entity.lang. Empty state if no classes today.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/teacher-today-schedule.swift`
- `hogwarts/features/dashboard/viewmodels/teacher-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` (role=teacher) → `{ today: [{ period, subject, className, room, startsAt, endsAt }] }`

## i18n Keys
- `home.teacher.today.title`, `home.teacher.today.current`, `home.teacher.today.empty`, `home.teacher.today.room`

## Tests
- `HogwartsTests/dashboard/teacher-today-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-002, TT-004
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
