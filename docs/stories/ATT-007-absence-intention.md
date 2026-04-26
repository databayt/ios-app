# ATT-007: Absence Intention (Planned Absence)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
As a guardian, I want to declare a planned absence in advance (e.g., family travel), so that the school knows ahead of time.

## Acceptance Criteria
### AC-1: Future-dated only
**Given** I open Plan Absence **When** I pick today or past **Then** the picker disables those; only future dates are selectable.

### AC-2: Submit + status
**Given** I submit **When** the request reaches server **Then** I see a confirmation and the absence appears in my child's timeline as "Planned".

### AC-3: Cross-cutting
Localized labels. RTL form. Audit logged. Multi-tenant isolated.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (guardian only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/absence-intention-view.swift`
- `hogwarts/features/attendance/viewmodels/absence-intention-viewmodel.swift`
- `hogwarts/features/attendance/services/excuse-service.swift`

## API Contract
- `POST /api/mobile/attendance/intentions` — body `{ childId, fromDate, toDate, reason }`

## i18n Keys
- `attendance.intention.title`, `attendance.intention.future_only`, `attendance.intention.submitted`, `attendance.intention.planned`

## Tests
- `HogwartsTests/attendance/absence-intention-tests.swift`
- Date validation test

## Dependencies
- Depends on: ATT-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
