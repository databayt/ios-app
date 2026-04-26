# EXAM-T-001: Teacher Author Exam from Question Bank

**Epic**: EXAMS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to compose an exam by picking questions from the question bank
**So that** I can reuse vetted questions and build exams quickly

## Acceptance Criteria

### AC-1: QBank browser
**Given** the teacher opens "New Exam" **When** the QBank panel appears **Then** they can search/filter by subject, difficulty, topic, and tap to add to the exam draft.

### AC-2: Reorder + edit
**Given** questions are added **When** the teacher drags or edits **Then** order persists and per-question point overrides are saved on the draft.

### AC-3: Save draft
**Given** the exam draft is incomplete **When** the teacher taps Save Draft **Then** the draft persists with `school_id` and can be resumed later.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `generate`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged

## Files
- `hogwarts/features/exams/views/teacher-author-exam-view.swift`
- `hogwarts/features/exams/views/qbank-picker-view.swift`
- `hogwarts/features/exams/viewmodels/author-exam-viewmodel.swift`

## API Contract
- `GET /api/mobile/teacher/qbank?subject=...&topic=...` — questions list
- `POST /api/mobile/teacher/exams` — `{ title, questions: [...] }` → `{ exam_id, status: draft }`

## i18n Keys
- `marking.author.title`, `marking.author.qbank`, `marking.author.save_draft`

## Tests
- `HogwartsTests/exams/teacher-author-exam-tests.swift`

## Dependencies
- Depends on: CORE-001, CORE-006
- Blocks: EXAM-T-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
