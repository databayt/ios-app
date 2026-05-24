# ATT-005: Charts (Week/Month/Term)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student or guardian, I want trend charts (week/month/term), so that I can spot patterns over time.

## Acceptance Criteria
### AC-1: Switch granularity
**Given** I open Charts **When** I tap Week/Month/Term toggle **Then** the chart switches data granularity smoothly.

### AC-2: Tap a bar for detail
**Given** I tap a bar **When** the bottom sheet opens **Then** I see the records contributing to that bar.

### AC-3: Cross-cutting
Axis labels localized. RTL: x-axis reads right-to-left. Arabic-Indic numerals.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, guardian)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/attendance/views/attendance-charts-view.swift`
- `hogwarts/features/attendance/viewmodels/charts-viewmodel.swift`

## API Contract
- `GET /api/mobile/attendance/charts?granularity=week|month|term` → `{ series: [{ label, value }] }`

## i18n Keys
- `attendance.charts.title`, `attendance.charts.week`, `attendance.charts.month`, `attendance.charts.term`

## Tests
- `HogwartsTests/attendance/charts-tests.swift`
- Snapshot AR + EN per granularity

## Dependencies
- Depends on: ATT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
