# DASH-S-002: Student Attendance + GPA Cards

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want quick-glance attendance % and current GPA cards, so that I know my standing.

## Acceptance Criteria
### AC-1: Cards render numbers
**Given** dashboard loads **When** cards render **Then** I see attendance % (term-to-date) and GPA (current semester) with trend arrow.

### AC-2: Tap navigates to detail
**Given** I tap the attendance card **When** the navigation runs **Then** I land on Attendance summary; tapping GPA goes to Grades.

### AC-3: Cross-cutting
Arabic-Indic digits for `ar`. RTL trend arrows respect language. Threshold colors (green/amber/red) WCAG AA.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `attendance`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/student-attendance-card.swift`
- `hogwarts/features/dashboard/views/student-gpa-card.swift`
- `hogwarts/features/dashboard/viewmodels/student-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` → `{ attendance: { percent, trend }, gpa: { value, trend } }`

## i18n Keys
- `home.card.attendance`, `home.card.gpa`, `home.trend.up`, `home.trend.down`, `home.trend.flat`

## Tests
- `HogwartsTests/dashboard/student-cards-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-S-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
