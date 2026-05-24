# ATT-001: Student History List

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student or guardian, I want a chronological list of my (or my child's) attendance records, so that I review history.

## Acceptance Criteria
### AC-1: Paginated list
**Given** I open Attendance **When** History loads **Then** I see records (date, subject, status) in reverse-chronological order, paginated 30 at a time.

### AC-2: Offline cache
**Given** I am offline **When** I open History **Then** I see cached records with stale banner.

### AC-3: Cross-cutting
Status labels localized. RTL list. Subject names entity.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student own; guardian = linked children)
- [ ] Audit logged (n/a — read)

## Files
- `hogwarts/features/attendance/views/student-history-list.swift`
- `hogwarts/features/attendance/viewmodels/student-attendance-viewmodel.swift`
- `hogwarts/features/attendance/services/attendance-service.swift`

## API Contract
- `GET /api/mobile/attendance/history?cursor=...` → `[{ date, subject, status }]`

## i18n Keys
- `attendance.history.title`, `attendance.status.present`, `attendance.status.absent`, `attendance.status.late`, `attendance.status.excused`

## Tests
- `HogwartsTests/attendance/history-list-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: ATT-002, ATT-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
