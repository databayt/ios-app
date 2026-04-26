# STR-007: Lesson quiz

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to take a lesson quiz inside the course
**So that** I test understanding

## Acceptance Criteria

### AC-1: Take
**Given** quiz lesson **When** opened **Then** questions presented one-at-a-time; answers stored locally.

### AC-2: Submit + score
**Given** all answered **When** I submit **Then** score returned; pass marks lesson complete.

### AC-3: Cross-cutting
**Given** questions in `quiz.lang` **When** rendering **Then** font + direction respected; tenant-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `generate`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Entity content lang
- [ ] Audit logged on submit

## Files
- `hogwarts/features/stream/views/lesson-quiz-view.swift`
- `hogwarts/features/stream/viewmodels/lesson-quiz-viewmodel.swift`
- `hogwarts/features/stream/services/quiz-actions.swift`

## API Contract
- `GET /api/mobile/lessons/:id` — quiz payload (questions, answers hidden)
- `POST /api/mobile/stream/lessons/:id/quiz/submit` — `{ answers[] } → { score, passed }`

## i18n Keys
- `common.stream.quiz.next_question`
- `common.stream.quiz.submit`
- `common.stream.quiz.score`
- `common.stream.quiz.passed`
- `common.stream.quiz.failed_retry`

## Tests
- `HogwartsTests/stream/lesson-quiz-tests.swift`

## Dependencies
- Depends on: STR-004, SUB-005
- Blocks: STR-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
