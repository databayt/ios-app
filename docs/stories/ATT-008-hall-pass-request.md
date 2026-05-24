# ATT-008: Hall Pass Request

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want to request a hall pass during class, so that I can briefly leave (bathroom, nurse) with teacher approval.

## Acceptance Criteria
### AC-1: Request flow
**Given** I am in a class period **When** I tap "Request Hall Pass" **Then** the form picks reason and submits; teacher receives a notification.

### AC-2: Status updates
**Given** my request was approved **When** the push arrives **Then** I see status change to "Approved" with timestamp.

### AC-3: Cross-cutting
Reasons localized. RTL form. Audit logged. Guarded by current-period detection.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/hall-pass-request-view.swift`
- `hogwarts/features/attendance/viewmodels/hall-pass-viewmodel.swift`
- `hogwarts/features/attendance/services/hall-pass-service.swift`

## API Contract
- `POST /api/mobile/attendance/hall-pass` — body `{ classId, reason }`
- `GET /api/mobile/attendance/hall-pass/:id` — status polling

## i18n Keys
- `attendance.hall_pass.title`, `attendance.hall_pass.reason.bathroom`, `attendance.hall_pass.reason.nurse`, `attendance.hall_pass.status.pending`, `attendance.hall_pass.status.approved`

## Tests
- `HogwartsTests/attendance/hall-pass-request-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: TT-001
- Blocks: ATT-T-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
