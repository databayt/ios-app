# TT-002: Timetable Week View

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student or teacher, I want a swipeable week grid, so that I see my whole week and can navigate weeks.

## Acceptance Criteria
### AC-1: Week grid renders
**Given** I tap Week **When** the grid loads **Then** I see days as columns and periods as rows; today's column is highlighted.

### AC-2: Swipe paginates
**Given** I swipe horizontally **When** the gesture completes **Then** the grid loads previous/next week with smooth animation.

### AC-3: Cross-cutting
Week starts on `School.weekStartsOn`. RTL: today/leading column flipped. Times locale-formatted. 120Hz scroll target.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, teacher)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/timetable/views/timetable-week-view.swift`
- `hogwarts/features/timetable/viewmodels/timetable-week-viewmodel.swift`

## API Contract
- `GET /api/mobile/timetable/:userId?week=YYYY-WW` → `[[{day, classes:[...]}]]`

## i18n Keys
- `common.timetable.week`, `common.timetable.weekday.<n>`, `common.timetable.period`

## Tests
- `HogwartsTests/timetable/week-view-tests.swift`
- Snapshot AR + EN + light/dark; week-starts-on Saturday vs Monday

## Dependencies
- Depends on: TT-001
- Blocks: TT-005, TT-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, week-start-day correct, parity preserved
