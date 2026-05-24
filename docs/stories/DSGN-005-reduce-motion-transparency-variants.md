# DSGN-005: Reduce Motion / Reduce Transparency Variants

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** user with motion sensitivity
**I want** animations to collapse and translucency to become solid when system flags are on
**So that** the app respects my accessibility preferences

## Acceptance Criteria

### AC-1: Reduce Motion path
**Given** `accessibilityReduceMotion == true` **When** any atom animates **Then** the animation duration becomes 0 and opacity-only transitions remain.

### AC-2: Reduce Transparency path
**Given** `accessibilityReduceTransparency == true` **When** a glass surface renders **Then** it swaps to a solid material token.

### AC-3: Snapshot tests
**Given** snapshot suite **When** run **Then** every atom has Reduce-Motion + Reduce-Transparency variants captured.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)

## Files
- `hogwarts/design/accessibility/motion-aware.swift` — `@Environment` reader + helper
- `hogwarts/atoms/*` — apply helper in animation/material call sites

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/design/reduce-motion-snapshots/*`, `reduce-transparency-snapshots/*`

## Dependencies
- Depends on: DSGN-002, DSGN-003
- Blocks: DSGN-008

## Definition of Done
- [ ] AC met, snapshot matrix green, manual real-device verification at both flags on
