# A11Y-004: Reduce Transparency Variants

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user with Reduce Transparency enabled
**I want** opaque backgrounds in place of materials/blurs
**So that** the UI is readable

## Acceptance Criteria

### AC-1: Opaque fallback
**Given** Reduce Transparency ON
**When** materials are used
**Then** views fall back to opaque backgrounds while respecting tokens

### AC-2: SwiftUI env wired
**Given** views
**When** they style
**Then** they consult `\.accessibilityReduceTransparency`

### AC-3: Snapshot both modes
**Given** snapshot CI
**When** runs
**Then** affected screens have transparency-on and transparency-off snapshots

## Cross-Cutting Invariants
- [ ] All material atoms updated
- [ ] Token-driven, no hardcoded colors

## Files
- `hogwarts/components/atom/material-*.swift`
- `hogwarts/core/theme/transparency-helpers.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/a11y/reduce-transparency-tests.swift`

## Dependencies
- Depends on: TEST-004
- Blocks: —

## Definition of Done
- [ ] AC met, all materials adapt, snapshots committed
