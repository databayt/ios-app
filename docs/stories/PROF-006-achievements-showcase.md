# PROF-006: Achievements Showcase

**Epic**: PROFILE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want to see my earned badges and milestones, so that I feel recognized for progress.

## Acceptance Criteria
### AC-1: Grid of badges
**Given** I open Achievements **When** the view loads **Then** I see earned badges (full-color) and locked ones (grey) with criteria on tap.

### AC-2: Empty state
**Given** I have no achievements yet **When** the view loads **Then** I see an encouraging empty state, not a blank screen.

### AC-3: Cross-cutting
Badge titles render in `entity.lang`. RTL grid orders right-to-left. Numbers locale-formatted.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/profile/views/achievements-view.swift`
- `hogwarts/features/profile/viewmodels/achievements-viewmodel.swift`
- `hogwarts/features/profile/services/achievements-service.swift`
- `hogwarts/features/profile/models/achievement-model.swift`

## API Contract
- `GET /api/mobile/profile/achievements` → `[{ id, title, description, earnedAt?, iconUrl, criteria }]`

## i18n Keys
- `profile.achievements.title`, `profile.achievements.locked`, `profile.achievements.empty`

## Tests
- `HogwartsTests/profile/achievements-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: PROF-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
