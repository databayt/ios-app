# HOME-003: Tile Customization (Long-press Jiggle)

**Epic**: HOME
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to long-press tiles to enter jiggle mode, then drag to reorder or hide them, so that my home feels mine.

## Acceptance Criteria
### AC-1: Enter jiggle
**Given** I long-press a tile **When** the haptic fires **Then** all tiles begin jiggling and a delete badge appears.

### AC-2: Reorder + hide persists
**Given** I drag tile A onto tile B's slot **When** I tap Done **Then** the new order persists across launches; hiding a tile removes it from the grid.

### AC-3: Cross-cutting
Reduce Motion suppresses jiggle (still functional via static badges). RTL: drag origin/destination respects layout direction.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/home/views/home-tile-jiggle-view.swift`
- `hogwarts/features/home/viewmodels/home-customization-viewmodel.swift`
- `hogwarts/features/home/services/home-layout-store.swift`

## API Contract
- (none — local preference)

## i18n Keys
- `home.customize.done`, `home.customize.hide`, `home.customize.reset`

## Tests
- `HogwartsTests/home/tile-customization-tests.swift`
- Reduce-motion behavior test

## Dependencies
- Depends on: HOME-002, SET-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, reduce-motion variant verified, parity preserved
