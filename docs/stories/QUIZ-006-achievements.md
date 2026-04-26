# QUIZ-006: Achievements

**Epic**: QUIZ
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to unlock and view achievements
**So that** I feel rewarded

## Acceptance Criteria

### AC-1: List
**Given** Quiz hub → Achievements **When** loaded **Then** locked + unlocked badges shown with criteria.

### AC-2: Unlock animation
**Given** I meet criteria mid-session **When** unlock **Then** subtle banner; respects Reduce Motion.

### AC-3: Cross-cutting
**Given** badges **When** rendered **Then** name + description in `app.language`; persisted per `<schoolId>:<userId>`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`, `common`)
- [ ] RTL-tested
- [ ] schoolId in storage key
- [ ] Reduce Motion respected
- [ ] VoiceOver accessibility traits on badges

## Files
- `hogwarts/features/quiz/views/achievements-view.swift`
- `hogwarts/features/quiz/viewmodels/achievements-viewmodel.swift`
- `hogwarts/features/quiz/models/achievement-model.swift` — `@Model` with `schoolId`, `userId`

## API Contract
- `GET /api/mobile/quiz/achievements` — `[ { id, name, description, unlocked, criteria } ]`

## i18n Keys
- `generate.achievements.title`
- `generate.achievements.locked`
- `generate.achievements.unlocked`

## Tests
- `HogwartsTests/quiz/achievements-tests.swift`
- Reduce Motion test, VoiceOver test

## Dependencies
- Depends on: QUIZ-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, accessibility verified
