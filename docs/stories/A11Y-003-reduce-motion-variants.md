# A11Y-003: Reduce Motion Variants

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user with motion sensitivity
**I want** the app to respect Reduce Motion
**So that** parallax/spring effects do not cause discomfort

## Acceptance Criteria

### AC-1: Disable parallax/spring
**Given** Reduce Motion ON
**When** any animated transition fires
**Then** crossfade or instant transition replaces parallax/spring

### AC-2: SwiftUI accessibility env
**Given** views
**When** they animate
**Then** they use `@Environment(\.accessibilityReduceMotion)` and adapt

### AC-3: Snapshot in both modes
**Given** snapshot CI
**When** runs
**Then** screens with motion have snapshots in motion-on and motion-off

## Cross-Cutting Invariants
- [ ] All animated atoms updated
- [ ] No implicit `.animation` on key surfaces

## Files
- `hogwarts/core/motion/motion-helpers.swift`
- `hogwarts/components/atom/**` — animation refactor

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/a11y/reduce-motion-tests.swift`

## Dependencies
- Depends on: TEST-004
- Blocks: —

## Definition of Done
- [ ] AC met, all key surfaces respect Reduce Motion
