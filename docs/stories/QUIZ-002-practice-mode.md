# QUIZ-002: Practice mode

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** an untimed practice mode by subject
**So that** I learn without pressure

## Acceptance Criteria

### AC-1: Pick subject
**Given** practice mode **When** I pick subject **Then** session starts with 10 questions.

### AC-2: Per-question feedback
**Given** I answer **When** correct/incorrect **Then** explanation shown immediately.

### AC-3: Cross-cutting
**Given** questions in `quiz.lang` **When** rendering **Then** font + direction respected.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`)
- [ ] RTL-tested
- [ ] schoolId on session start
- [ ] Entity content lang

## Files
- `hogwarts/features/quiz/views/practice-session-view.swift`
- `hogwarts/features/quiz/viewmodels/practice-viewmodel.swift`

## API Contract
- `POST /api/mobile/quiz/sessions` — `{ mode:"practice", subject_id } → { session_id, questions:[ { id, prompt, lang, options[] } ] }`
- `POST /api/mobile/quiz/sessions/:id/answers` — `{ question_id, answer } → { correct, explanation, lang }`

## i18n Keys
- `generate.practice.title`
- `generate.practice.next_question`
- `generate.practice.explanation`

## Tests
- `HogwartsTests/quiz/practice-tests.swift`

## Dependencies
- Depends on: QUIZ-001, QUIZ-007
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
