# DASH-T-002: Teacher Pending Grades + Attendance

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want a card listing pending grade entries and unmarked attendance for today, so that I close my loops.

## Acceptance Criteria
### AC-1: Pending counts
**Given** dashboard loads **When** the card renders **Then** I see "X assignments to grade" and "Y classes unmarked today" with tap-through.

### AC-2: Tap routes correctly
**Given** I tap unmarked attendance **When** navigation runs **Then** I land on the bulk-mark screen for the next class needing it.

### AC-3: Cross-cutting
Numbers locale-formatted. RTL card. Empty state hides card.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `attendance`, `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/teacher-pending-card.swift`
- `hogwarts/features/dashboard/viewmodels/teacher-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` → `{ pending: { grading, unmarkedClasses } }`

## i18n Keys
- `home.teacher.pending.grading`, `home.teacher.pending.attendance`, `home.teacher.pending.empty`

## Tests
- `HogwartsTests/dashboard/teacher-pending-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-T-001, ATT-T-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
