# ATT-T-008: Excuse Review (Approve/Reject)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to review and approve/reject parent-submitted excuses with the doctor's note attached, so that I close the loop fairly.

## Acceptance Criteria
### AC-1: Pending list
**Given** I open Excuse Review **When** the list loads **Then** I see pending excuses with child name, date(s), reason, and attachment thumbnail.

### AC-2: Approve / Reject
**Given** I tap Approve **When** the action posts **Then** child's record updates to Excused; parent gets a push.

### AC-3: Cross-cutting
RTL list. Reason localized. Note image fetched on demand. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/excuse-review-list.swift`
- `hogwarts/features/attendance/views/excuse-review-detail.swift`
- `hogwarts/features/attendance/viewmodels/excuse-review-viewmodel.swift`

## API Contract
- `GET /api/mobile/attendance/excuses?status=pending` → `[{ ... }]`
- `POST /api/mobile/attendance/excuses/:id/approve|reject`

## i18n Keys
- `attendance.excuse_review.title`, `attendance.excuse_review.approve`, `attendance.excuse_review.reject`, `attendance.excuse_review.note`

## Tests
- `HogwartsTests/attendance/excuse-review-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: ATT-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
