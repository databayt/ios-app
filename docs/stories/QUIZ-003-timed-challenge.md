# QUIZ-003: Timed challenge

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a timed quiz challenge with score
**So that** I compete against the clock

## Acceptance Criteria

### AC-1: Timer
**Given** timed mode **When** session starts **Then** timer counts down (default 60s); session ends at 0.

### AC-2: Score
**Given** session ends **When** scored **Then** score recorded; comparable on leaderboard (QUIZ-005).

### AC-3: Cross-cutting
**Given** Reduce Motion ON **When** timer animates **Then** uses simple progress bar, not pulsing/glowing animations.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Entity content lang
- [ ] Reduce Motion respected
- [ ] Timer uses 12h/24h locale-aware (display only)

## Files
- `hogwarts/features/quiz/views/timed-challenge-view.swift`
- `hogwarts/features/quiz/viewmodels/timed-viewmodel.swift`
- `hogwarts/features/quiz/services/quiz-actions.swift`

## API Contract
- `POST /api/mobile/quiz/sessions` — `{ mode:"timed", subject_id, duration_sec }`
- `POST /api/mobile/quiz/sessions/:id/finish` — score finalize

## i18n Keys
- `generate.timed.title`
- `generate.timed.time_left`
- `generate.timed.score`
- `generate.timed.timeup`

## Tests
- `HogwartsTests/quiz/timed-challenge-tests.swift`
- Reduced Motion test

## Dependencies
- Depends on: QUIZ-001, QUIZ-007
- Blocks: QUIZ-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, Reduce Motion verified
