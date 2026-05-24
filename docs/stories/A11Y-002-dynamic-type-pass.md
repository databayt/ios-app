# A11Y-002: Dynamic Type Pass

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user with large text preferences
**I want** the app to scale text up to AX5 without breaking layouts
**So that** I can read comfortably

## Acceptance Criteria

### AC-1: AX5 layout integrity
**Given** Dynamic Type set to AX5
**When** any M0 screen renders
**Then** no truncation, clipping, or overlap (vertical layouts adapt)

### AC-2: System font usage
**Given** components
**When** rendered
**Then** all use scaled system fonts; no fixed point sizes

### AC-3: Snapshot 1x + 3x
**Given** snapshot CI
**When** runs
**Then** every screen has 1x and 3x snapshots

## Cross-Cutting Invariants
- [ ] Localized strings (no English-pinned heights)
- [ ] RTL + LTR verified

## Files
- `hogwarts/components/atom/**` — typography refactor
- `HogwartsTests/a11y/dynamic-type-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Dynamic Type AX5 snapshot per screen

## Dependencies
- Depends on: TEST-004
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, AX5 renders without truncation, snapshots committed
