# ASGN-T-003: Teacher Grade + Feedback

**Epic**: ASSIGNMENTS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to grade a submission and attach inline + overall feedback
**So that** the student receives a score and constructive comments

## Acceptance Criteria

### AC-1: Score + comment
**Given** a submission is open **When** the teacher enters a score within bounds and an optional comment **Then** the entry validates and Save persists with `school_id` + `feedback_lang`.

### AC-2: Inline annotations
**Given** the submission is a PDF or rich text **When** the teacher long-presses to add inline annotation **Then** the annotation anchors to the location and saves with the submission.

### AC-3: Notify student
**Given** Save Grade is tapped **When** the request resolves **Then** a push notification is dispatched to the student.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged with `assignment.grade`

## Files
- `hogwarts/features/assignments/views/teacher-grade-feedback-view.swift`
- `hogwarts/features/assignments/viewmodels/grade-feedback-viewmodel.swift`
- `hogwarts/features/assignments/services/grade-feedback-service.swift`

## API Contract
- `POST /api/mobile/teacher/assignments/:id/submissions/:sid/grade` — `{ score, max, comment, comment_lang, annotations: [...] }`

## i18n Keys
- `marking.asgn.grade`, `marking.asgn.feedback_overall`, `marking.asgn.annotation`

## Tests
- `HogwartsTests/assignments/teacher-grade-tests.swift`
- Multi-tenant isolation
- Audit log assertion

## Dependencies
- Depends on: ASGN-T-002
- Blocks: ASGN-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
