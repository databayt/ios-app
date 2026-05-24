# QUIZ-007: Quiz session

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a unified quiz session UI for all modes
**So that** I have a consistent answering experience

## Acceptance Criteria

### AC-1: Single-question screen
**Given** session **When** active **Then** one question + N options with single-tap answer; haptic on answer.

### AC-2: Resume
**Given** I background mid-session **When** I return **Then** resume from current question (state persisted).

### AC-3: Cross-cutting
**Given** question + options in `quiz.lang` **When** rendering **Then** font + direction respected per question.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`)
- [ ] RTL-tested
- [ ] schoolId in session storage
- [ ] Entity content lang per question
- [ ] Audit logged on submit

## Files
- `hogwarts/features/quiz/views/quiz-session-view.swift`
- `hogwarts/features/quiz/viewmodels/quiz-session-viewmodel.swift`
- `hogwarts/features/quiz/models/quiz-session-model.swift` — `@Model` with `schoolId`

## API Contract
- (consumes QUIZ-002/003/004 endpoints)

## i18n Keys
- `generate.session.next`
- `generate.session.exit`
- `generate.session.resume`

## Tests
- `HogwartsTests/quiz/quiz-session-tests.swift`
- Resume after background test

## Dependencies
- Depends on: QUIZ-001
- Blocks: QUIZ-002, QUIZ-003, QUIZ-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
