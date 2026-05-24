# ATT-003: Streaks View

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want to see my current and longest perfect-attendance streaks, so that I am motivated to maintain them.

## Acceptance Criteria
### AC-1: Current + longest
**Given** I open Streaks **When** the view loads **Then** I see current streak (days), longest streak, and a 14-day calendar strip with daily status.

### AC-2: Broken-streak state
**Given** my streak just broke **When** the view loads **Then** the current streak shows "0 days" with encouraging copy.

### AC-3: Cross-cutting
Numbers locale-formatted. RTL strip reads right-to-left.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/attendance/views/streaks-view.swift`
- `hogwarts/features/attendance/viewmodels/streaks-viewmodel.swift`

## API Contract
- `GET /api/mobile/attendance/streaks` → `{ current, longest, calendar: [...] }`

## i18n Keys
- `attendance.streaks.title`, `attendance.streaks.current`, `attendance.streaks.longest`, `attendance.streaks.broken`

## Tests
- `HogwartsTests/attendance/streaks-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: ATT-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
