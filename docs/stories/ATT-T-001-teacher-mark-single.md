# ATT-T-001: Teacher Mark Single (per Student)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to mark attendance for one student at a time, so that I can correct records or do a quick spot mark.

## Acceptance Criteria
### AC-1: Per-student segmented control
**Given** I open a class roster **When** I tap a student row **Then** a segmented control (Present/Absent/Late/Excused) appears; selecting writes the record.

### AC-2: Optimistic + rollback
**Given** I mark Late but server rejects **When** the failure returns **Then** the row reverts and a toast explains.

### AC-3: Cross-cutting
Status labels localized. RTL row. schoolId enforced. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/teacher-mark-single-view.swift`
- `hogwarts/features/attendance/viewmodels/teacher-mark-viewmodel.swift`
- `hogwarts/features/attendance/services/attendance-service.swift`

## API Contract
- `POST /api/mobile/attendance/mark` — body `{ studentId, classId, date, status }`

## i18n Keys
- `attendance.mark.single.title`, `attendance.status.present`, `attendance.status.absent`, `attendance.status.late`, `attendance.status.excused`

## Tests
- `HogwartsTests/attendance/teacher-mark-single-tests.swift`
- Optimistic + rollback test; multi-tenant isolation

## Dependencies
- Depends on: TT-004
- Blocks: ATT-T-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
