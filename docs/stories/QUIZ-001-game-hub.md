# QUIZ-001: Game hub

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a game hub with modes (practice, timed, tournament)
**So that** I pick how to play

## Acceptance Criteria

### AC-1: Hub
**Given** I open Quiz **When** loaded **Then** hub shows mode tiles + my XP + recent achievements.

### AC-2: Tap mode
**Given** tile **When** tapped **Then** routes to QUIZ-002/003/004.

### AC-3: Cross-cutting
**Given** copy localized **When** rendering **Then** subject buttons in `subject.lang`; tenant-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang for subject tiles

## Files
- `hogwarts/features/quiz/views/quiz-hub-view.swift`
- `hogwarts/features/quiz/viewmodels/quiz-hub-viewmodel.swift`

## API Contract
- `GET /api/mobile/quiz/hub` — `{ xp, recent_achievements[] }` (P2 backend)

## i18n Keys
- `generate.quiz.hub.title`
- `generate.quiz.hub.mode.practice`
- `generate.quiz.hub.mode.timed`
- `generate.quiz.hub.mode.tournament`

## Tests
- `HogwartsTests/quiz/quiz-hub-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: QUIZ-002, QUIZ-003, QUIZ-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot
