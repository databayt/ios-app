# DSGN-004: Dynamic Type Pass — 0.85x to 3x

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** user with low-vision needs
**I want** every screen to scale text from 0.85x up to 3x without breaking layout
**So that** the app remains usable at my preferred reading size

## Acceptance Criteria

### AC-1: All text scales
**Given** Settings → Display & Text Size → Larger Text **When** maxed **Then** every label, button, and heading scales without clipping; multi-line wraps gracefully.

### AC-2: No fixed-size fonts
**Given** the codebase **When** grepped for `.font(.system(size:` literals **Then** zero remain; everything uses semantic styles (`.hwHeadline`, `.hwBody`).

### AC-3: Snapshot matrix
**Given** every screen **When** snapshot tests run **Then** DT 0.85x and DT 3x snapshots exist and pass.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`) — Arabic also scales
- [ ] RTL-tested at DT 3x

## Files
- `hogwarts/design/typography/font-scale.swift` — semantic style registry
- `hogwarts/atoms/*` — sweep replacing fixed sizes

## API Contract
- None.

## i18n Keys
- None (typography only).

## Tests
- `HogwartsTests/design/dynamic-type-snapshots/*` — every screen × DT 0.85x, 3x

## Dependencies
- Depends on: DSGN-002
- Blocks: every feature epic UI

## Definition of Done
- [ ] AC met, snapshot matrix green, audit script for fixed sizes clean
