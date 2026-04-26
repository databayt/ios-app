# GRADE-T-003: Teacher Rubric-Based Grading

**Epic**: GRADES
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to grade against a structured rubric with per-criterion scores
**So that** my marking is consistent and transparent for students

## Acceptance Criteria

### AC-1: Rubric criteria
**Given** an assessment has a rubric **When** the teacher opens grading **Then** each criterion appears as a row with a score input bounded by max points.

### AC-2: Auto-total
**Given** the teacher fills in criterion scores **When** values change **Then** the total updates instantly with locale numerals.

### AC-3: Comment per criterion
**Given** the teacher taps a criterion's comment icon **When** the modal opens **Then** they can write feedback in their preferred lang and save it scoped to that criterion.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged

## Files
- `hogwarts/features/grades/views/teacher-rubric-grading-view.swift`
- `hogwarts/features/grades/viewmodels/rubric-grading-viewmodel.swift`
- `hogwarts/features/grades/models/rubric.swift`

## API Contract
- `POST /api/mobile/teacher/classes/:id/grades/rubric` — `{ student_id, assessment_id, criteria: [{ id, score, comment? }] }`

## i18n Keys
- `marking.rubric.criterion`, `marking.rubric.total`, `marking.rubric.comment`

## Tests
- `HogwartsTests/grades/rubric-grading-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: GRADE-T-001
- Blocks: GRADE-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
