# ATT-002: Summary Card (% Present, by Subject)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student or guardian, I want a summary card with % present overall and per-subject breakdown, so that I see trends at a glance.

## Acceptance Criteria
### AC-1: Overall + per-subject
**Given** I open Attendance **When** Summary loads **Then** I see overall % and a list of subjects each with their % and count.

### AC-2: Threshold colors
**Given** a subject has <80% **When** the row renders **Then** it shows an amber warning indicator; <60% red.

### AC-3: Cross-cutting
Arabic-Indic digits. RTL row layout. Subject names entity.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, guardian)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/attendance/views/student-summary-card.swift`
- `hogwarts/features/attendance/viewmodels/student-attendance-viewmodel.swift`

## API Contract
- `GET /api/mobile/attendance/summary` → `{ overallPct, subjects: [{ name, pct, present, total }] }`

## i18n Keys
- `attendance.summary.overall`, `attendance.summary.by_subject`, `attendance.summary.warning`

## Tests
- `HogwartsTests/attendance/summary-card-tests.swift`
- Threshold color test

## Dependencies
- Depends on: ATT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
