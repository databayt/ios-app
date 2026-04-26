# EXAM-T-004: Teacher Publish Exam Results

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to publish all graded exam results in one batch
**So that** students see results only when grading is complete

## Acceptance Criteria

### AC-1: Batch publish
**Given** all submissions are graded **When** the teacher taps Publish Results **Then** every submission flips to `published` and a push notification is sent to each student.

### AC-2: Incomplete blocked
**Given** any submission is still ungraded **When** Publish is tapped **Then** an alert lists ungraded submissions and blocks the action.

### AC-3: Confirmation
**Given** Publish is tapped with all submissions graded **When** the action sheet appears **Then** it shows "Publish N results?" with Cancel.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged with `exam.publish_results`

## Files
- `hogwarts/features/exams/views/teacher-publish-results-view.swift`
- `hogwarts/features/exams/viewmodels/publish-results-viewmodel.swift`

## API Contract
- `POST /api/mobile/teacher/exams/:id/publish-results` — `{}` → `{ published_count }`

## i18n Keys
- `marking.exam.publish_results`, `marking.exam.publish_blocked`, `marking.exam.publish_confirm`

## Tests
- `HogwartsTests/exams/publish-results-tests.swift`

## Dependencies
- Depends on: EXAM-T-003
- Blocks: EXAM-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
