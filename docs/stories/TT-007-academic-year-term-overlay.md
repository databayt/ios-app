# TT-007: Academic Year + Term Overlay

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want to see academic year and current term context in timetable, so that I know if I'm viewing this term's schedule.

## Acceptance Criteria
### AC-1: Header overlay
**Given** I open Timetable **When** the header renders **Then** I see "Year 2026 — Term 2" with term progress bar.

### AC-2: Term picker
**Given** I tap the header **When** the picker opens **Then** I can switch to past terms (read-only) or upcoming terms (preview).

### AC-3: Cross-cutting
Year/term labels localized. RTL header. Numbers locale-formatted.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/timetable/views/year-term-overlay.swift`
- `hogwarts/features/timetable/viewmodels/year-term-viewmodel.swift`

## API Contract
- `GET /api/mobile/academic/terms` → `[{ year, term, startsAt, endsAt, current }]`

## i18n Keys
- `common.timetable.year`, `common.timetable.term`, `common.timetable.term_progress`, `common.timetable.pick_term`

## Tests
- `HogwartsTests/timetable/year-term-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: TT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
