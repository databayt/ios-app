# QUIZ-005: Leaderboard

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a leaderboard scoped to my school
**So that** I see my standing

## Acceptance Criteria

### AC-1: List
**Given** Quiz hub → Leaderboard **When** loaded **Then** rows show rank, name, XP, school badge.

### AC-2: Period filter
**Given** filter **When** I pick "This week" / "All time" **Then** results scope.

### AC-3: Cross-cutting
**Given** server filters by `school_id` **When** results **Then** never includes other schools' players.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Numbers locale-formatted (Arabic-Indic in ar)

## Files
- `hogwarts/features/quiz/views/leaderboard-view.swift`
- `hogwarts/features/quiz/viewmodels/leaderboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/quiz/leaderboard?period=week|all` — `[ { rank, user_id, name, xp } ]` (P2 backend)

## i18n Keys
- `generate.leaderboard.title`
- `generate.leaderboard.period.week`
- `generate.leaderboard.period.all`
- `generate.leaderboard.rank`

## Tests
- `HogwartsTests/quiz/leaderboard-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: QUIZ-003, QUIZ-004
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, multi-tenant verified
