# SET-005: Accessibility Settings

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user with accessibility needs, I want to control Dynamic Type, Reduce Motion, and High Contrast, so that the app is comfortable for me.

## Acceptance Criteria
### AC-1: Dynamic Type honored
**Given** I increase Dynamic Type to XXXL **When** I scroll any screen **Then** text scales without clipping or overflow.

### AC-2: Reduce Motion suppresses animation
**Given** Reduce Motion is on **When** I navigate between screens **Then** push/pop transitions are crossfades only; jiggle and parallax disable.

### AC-3: Cross-cutting
High Contrast variant overrides theme. RTL preserved at all type sizes.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/settings/views/accessibility-settings-view.swift`
- `hogwarts/core/accessibility/accessibility-manager.swift`

## API Contract
- (none — local pref)

## i18n Keys
- `profile.accessibility.title`, `profile.accessibility.dynamic_type`, `profile.accessibility.reduce_motion`, `profile.accessibility.high_contrast`

## Tests
- `HogwartsTests/settings/accessibility-tests.swift`
- Dynamic Type snapshot at large sizes; reduce-motion behavior test

## Dependencies
- Depends on: SET-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot at XXXL, parity preserved
