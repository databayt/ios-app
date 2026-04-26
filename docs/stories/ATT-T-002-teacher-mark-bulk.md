# ATT-T-002: Teacher Bulk Mark (Whole Class)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to mark a whole class with one tap (default Present) and adjust outliers, so that I save time.

## Acceptance Criteria
### AC-1: All present default
**Given** I open Bulk Mark **When** the screen loads **Then** all students default to Present; I tap individuals to change.

### AC-2: Submit batches
**Given** I tap Submit **When** the batch posts **Then** all changes apply atomically; toast confirms count saved.

### AC-3: Cross-cutting
Offline queueing — submission queues, applies on reconnect. RTL: drag direction respects layout. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/teacher-mark-bulk-view.swift`
- `hogwarts/features/attendance/viewmodels/teacher-mark-bulk-viewmodel.swift`
- `hogwarts/features/attendance/services/attendance-service.swift`

## API Contract
- `POST /api/mobile/attendance/bulk` — body `{ classId, date, marks: [{ studentId, status }] }`

## i18n Keys
- `attendance.mark.bulk.title`, `attendance.mark.bulk.all_present`, `attendance.mark.bulk.submit`, `attendance.mark.bulk.queued_offline`

## Tests
- `HogwartsTests/attendance/teacher-mark-bulk-tests.swift`
- Offline queue test; multi-tenant isolation

## Dependencies
- Depends on: ATT-T-001
- Blocks: ATT-T-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
