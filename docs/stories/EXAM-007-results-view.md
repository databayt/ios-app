# EXAM-007: Exam Results View

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to view the result of a graded exam
**So that** I see the final score, breakdown, and teacher feedback

## Acceptance Criteria

### AC-1: Score and breakdown
**Given** an exam is graded and published **When** the user opens results **Then** the screen shows total score, percentage, per-question marking, and overall feedback.

### AC-2: Pending state
**Given** the exam is submitted but not yet graded **When** opened **Then** a "Pending grading" state appears with submission timestamp.

### AC-3: Comments in author lang
**Given** teacher feedback is in Arabic **When** the app is in English **Then** the feedback renders with Arabic font + RTL with a Translate affordance.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Comments respect `entity.lang`

## Files
- `hogwarts/features/exams/views/exam-results-view.swift`
- `hogwarts/features/exams/viewmodels/exam-results-viewmodel.swift`

## API Contract
- `GET /api/mobile/exams/:id/results` — `{ score, max, breakdown: [...], feedback, feedback_lang, status }`

## i18n Keys
- `results.exam.score`, `results.exam.feedback`, `results.exam.pending_grading`

## Tests
- `HogwartsTests/exams/results-view-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: EXAM-006, EXAM-T-004
- Blocks: EXAM-008, EXAM-009

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
