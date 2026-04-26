# EXAM-001: Upcoming Exams List

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see all upcoming exams sorted by date
**So that** I can plan study time and avoid missing any

## Acceptance Criteria

### AC-1: Sorted by date
**Given** upcoming exams exist **When** the list loads **Then** they sort ascending by start date with date label and countdown chip.

### AC-2: Today highlighted
**Given** an exam is today **When** the list renders **Then** the row uses an accent background and a "Today" badge.

### AC-3: Empty state
**Given** no upcoming exams **When** loaded **Then** an empty state with illustration and reassurance text appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Dates locale-formatted

## Files
- `hogwarts/features/exams/views/upcoming-list-view.swift`
- `hogwarts/features/exams/viewmodels/upcoming-list-viewmodel.swift`
- `hogwarts/features/exams/models/exam.swift`

## API Contract
- `GET /api/mobile/exams?status=upcoming` — `{ exams: [{ id, subject, start_at, room, type }] }`

## i18n Keys
- `marking.exams.upcoming`, `marking.exams.today`, `marking.exams.empty`

## Tests
- `HogwartsTests/exams/upcoming-list-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: CORE-001
- Blocks: EXAM-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
