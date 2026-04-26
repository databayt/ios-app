# DSGN-006: High Contrast Palette Swap

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** user with low vision
**I want** the app to swap to a high-contrast palette when Increase Contrast is enabled
**So that** all text and controls meet WCAG AAA contrast ratios

## Acceptance Criteria

### AC-1: Palette swap
**Given** `accessibilityDifferentiateWithoutColor == true` or Increase Contrast is on **When** colors render **Then** semantic tokens resolve to a high-contrast variant (foreground on background ≥ 7:1).

### AC-2: All tokens defined
**Given** every semantic token (`primary`, `secondary`, `surface`, etc.) **When** the asset catalog is inspected **Then** a `High Contrast` appearance variant exists.

### AC-3: Snapshot
**Given** snapshot tests **When** run **Then** Increase-Contrast variants exist for the dashboard + form screens at minimum.

## Cross-Cutting Invariants
- [ ] No hardcoded colors

## Files
- `hogwarts/design/Assets.xcassets/Colors/*` — add High Contrast variant per token
- `hogwarts/design/tokens/contrast.swift` — environment helper

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/design/high-contrast-snapshots/*` — dashboard, form, list

## Dependencies
- Depends on: DSGN-005
- Blocks: accessibility audits

## Definition of Done
- [ ] AC met, contrast checker (Xcode Accessibility Inspector) reports AAA, snapshots green
