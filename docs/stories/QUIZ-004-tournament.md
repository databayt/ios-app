# QUIZ-004: Tournament

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to join a tournament with peers
**So that** I compete in real time

## Acceptance Criteria

### AC-1: Join
**Given** scheduled tournament **When** I tap "Join" **Then** queued; live leaderboard updates as peers answer.

### AC-2: Final standings
**Given** tournament ends **When** finalized **Then** standings shown with top 3 highlighted.

### AC-3: Cross-cutting
**Given** server scopes by `school_id` **When** matchmaking **Then** only same-school peers join; no cross-tenant ranking.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`)
- [ ] RTL-tested
- [ ] schoolId on session
- [ ] Entity content lang
- [ ] Audit logged on join

## Files
- `hogwarts/features/quiz/views/tournament-view.swift`
- `hogwarts/features/quiz/viewmodels/tournament-viewmodel.swift`
- `hogwarts/features/quiz/services/tournament-socket.swift` — websocket

## API Contract
- `GET /api/mobile/quiz/tournaments` — list
- `POST /api/mobile/quiz/tournaments/:id/join`
- `WS /api/mobile/quiz/tournaments/:id/ws` — live updates

## i18n Keys
- `generate.tournament.join`
- `generate.tournament.live_leaderboard`
- `generate.tournament.final_standings`

## Tests
- `HogwartsTests/quiz/tournament-tests.swift`
- Multi-tenant matchmaking test

## Dependencies
- Depends on: QUIZ-001, QUIZ-007
- Blocks: QUIZ-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, multi-tenant verified
