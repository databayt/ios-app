# EXAM-T-003: Teacher Grade Essays (Manual Marking)

**Epic**: EXAMS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to manually grade essay answers with comments per question
**So that** open-ended responses receive proper feedback

## Acceptance Criteria

### AC-1: Per-question grader
**Given** a submission has essay questions **When** the teacher opens it **Then** each essay shows answer text, score input bounded to max, and a comment area.

### AC-2: Save per question
**Given** the teacher enters partial scores **When** they navigate forward **Then** the in-progress entry persists; total updates live.

### AC-3: Comment language
**Given** the teacher writes feedback in Arabic **When** saved **Then** the feedback persists with `feedback_lang=ar` so the student sees it with correct font + direction.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged

## Files
- `hogwarts/features/exams/views/teacher-grade-essay-view.swift`
- `hogwarts/features/exams/viewmodels/grade-essay-viewmodel.swift`

## API Contract
- `POST /api/mobile/teacher/exams/:id/submissions/:sid/essay` — `{ q_id, score, comment, comment_lang }`

## i18n Keys
- `marking.essay.score`, `marking.essay.comment`, `marking.essay.next`

## Tests
- `HogwartsTests/exams/grade-essay-tests.swift`

## Dependencies
- Depends on: EXAM-T-001
- Blocks: EXAM-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
