# ATT-T-007: Hall Pass Issue + End

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to approve a student's hall pass request and end it on return, so that hallway time is tracked.

## Acceptance Criteria
### AC-1: Approve / Deny request
**Given** I receive a hall-pass push **When** I tap Approve **Then** the student sees Approved status with start time.

### AC-2: End pass
**Given** the student returns **When** I tap End **Then** an end timestamp records and the duration logs to attendance.

### AC-3: Cross-cutting
Push delivery localized to recipient locale. RTL action sheet. schoolId enforced. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`, `notifications`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/hall-pass-issue-view.swift`
- `hogwarts/features/attendance/viewmodels/hall-pass-issue-viewmodel.swift`
- `hogwarts/features/attendance/services/hall-pass-service.swift`

## API Contract
- `POST /api/mobile/attendance/hall-pass/:id/approve`
- `POST /api/mobile/attendance/hall-pass/:id/deny`
- `POST /api/mobile/attendance/hall-pass/:id/end`

## i18n Keys
- `attendance.hall_pass.approve`, `attendance.hall_pass.deny`, `attendance.hall_pass.end`, `attendance.hall_pass.duration`

## Tests
- `HogwartsTests/attendance/hall-pass-issue-tests.swift`
- Push-driven flow

## Dependencies
- Depends on: ATT-008
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
