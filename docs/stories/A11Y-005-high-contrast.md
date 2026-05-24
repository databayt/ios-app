# A11Y-005: High Contrast

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user with Increase Contrast enabled
**I want** higher-contrast palette across the app
**So that** I can read clearly

## Acceptance Criteria

### AC-1: High-contrast tokens
**Given** Increase Contrast ON
**When** view renders
**Then** colors switch to high-contrast token variants

### AC-2: All screens covered
**Given** the app
**When** audited
**Then** no token uses low-contrast pair under high contrast

### AC-3: Snapshot covered
**Given** CI
**When** snapshot runs
**Then** high-contrast variant exists for top 30 screens

## Cross-Cutting Invariants
- [ ] Token-driven only
- [ ] AR + EN verified

## Files
- `hogwarts/core/theme/tokens-high-contrast.swift`
- `hogwarts/components/atom/**` — palette refactor

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/a11y/high-contrast-tests.swift`

## Dependencies
- Depends on: DSGN-006, TEST-004
- Blocks: —

## Definition of Done
- [ ] AC met, all top-30 covered, no low-contrast pairs
