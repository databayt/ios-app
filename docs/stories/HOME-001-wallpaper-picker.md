# HOME-001: Wallpaper Picker

**Epic**: HOME
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to pick a wallpaper from a bundled catalog, so that my home springboard feels personal.

## Acceptance Criteria
### AC-1: Catalog grid renders
**Given** I open Wallpaper Picker **When** the view loads **Then** I see all wallpapers from `Assets.xcassets` as a 2-column grid with current selection highlighted.

### AC-2: Apply persists
**Given** I tap a wallpaper **When** I tap Apply **Then** the home screen immediately updates and selection persists across launches.

### AC-3: Cross-cutting
RTL: grid order reads right-to-left; trailing alignment for highlight.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a — local UI)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/home/views/wallpaper-picker-view.swift`
- `hogwarts/features/home/viewmodels/wallpaper-picker-viewmodel.swift`
- `hogwarts/core/wallpaper/wallpaper-catalog.swift`

## API Contract
- (none — local pref)

## i18n Keys
- `home.wallpaper.title`, `home.wallpaper.apply`, `home.wallpaper.current`

## Tests
- `HogwartsTests/home/wallpaper-picker-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: —
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
