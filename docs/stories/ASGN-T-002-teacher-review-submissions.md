# ASGN-T-002: Teacher Review Submissions List

**Epic**: ASSIGNMENTS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to see all submissions for an assignment in one list
**So that** I can review progress and start grading

## Acceptance Criteria

### AC-1: Submissions list
**Given** the teacher opens an assignment **When** the submissions tab loads **Then** a list shows every assigned student with status (submitted/missing/late/graded) and timestamp.

### AC-2: Filter chips
**Given** the list is shown **When** the teacher taps a status chip **Then** only matching rows remain.

### AC-3: Bulk select
**Given** the teacher long-presses a row **When** bulk mode activates **Then** they can select multiple rows for batch actions (e.g., remind, mark missing).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/assignments/views/teacher-review-view.swift`
- `hogwarts/features/assignments/viewmodels/review-viewmodel.swift`

## API Contract
- `GET /api/mobile/teacher/assignments/:id/submissions` — `{ submissions: [{ student, status, submitted_at? }] }`

## i18n Keys
- `marking.asgn.review`, `marking.asgn.status.submitted`, `marking.asgn.status.missing`, `marking.asgn.status.late`

## Tests
- `HogwartsTests/assignments/teacher-review-tests.swift`

## Dependencies
- Depends on: ASGN-T-001
- Blocks: ASGN-T-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
