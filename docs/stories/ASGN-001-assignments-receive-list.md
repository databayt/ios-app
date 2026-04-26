# ASGN-001: Receive Assignments List (by Class, by Due Date)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see assignments grouped by class and sorted by due date
**So that** I can prioritize work and never miss a deadline

## Acceptance Criteria

### AC-1: Two view modes
**Given** the user opens Assignments **When** they toggle between "By Class" and "By Due Date" **Then** the list regroups while preserving scroll position.

### AC-2: Overdue badge
**Given** an assignment's due date passed and student has not submitted **When** rendered **Then** the row shows a red "Overdue" badge.

### AC-3: Empty state
**Given** no assignments exist **When** the view loads **Then** an empty state and CTA "Pull to refresh" appear.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Due dates locale-formatted

## Files
- `hogwarts/features/assignments/views/assignments-list-view.swift`
- `hogwarts/features/assignments/viewmodels/assignments-list-viewmodel.swift`
- `hogwarts/features/assignments/models/assignment.swift`

## API Contract
- `GET /api/mobile/assignments?status=open` — `{ assignments: [{ id, title, class, due_at, status }] }`

## i18n Keys
- `marking.asgn.by_class`, `marking.asgn.by_due_date`, `marking.asgn.overdue`, `marking.asgn.empty`

## Tests
- `HogwartsTests/assignments/list-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: CORE-001
- Blocks: ASGN-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
