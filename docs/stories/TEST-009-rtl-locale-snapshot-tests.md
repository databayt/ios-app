# TEST-009: RTL/Locale Snapshot Tests

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** RTL and pseudo-locale snapshot coverage on every screen
**So that** mirroring and translation issues are caught visually

## Acceptance Criteria

### AC-1: AR + EN per screen
**Given** the top 30 screens
**When** snapshots run
**Then** each has both `ar` (RTL) and `en` (LTR) variants

### AC-2: Pseudo-locale
**Given** a pseudo-locale (e.g., `ar-XA` style)
**When** snapshots render
**Then** truncation/missing-key issues fail the test

### AC-3: CI gate
**Given** a PR breaks RTL
**When** snapshots diff
**Then** PR is blocked

## Cross-Cutting Invariants
- [ ] All screens covered AR + EN
- [ ] String parity enforced (LOC-002)

## Files
- `HogwartsTests/_harness/locale-runner.swift`
- `HogwartsTests/locale/*-rtl-snapshot-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none — locale infrastructure)

## Tests
- One snapshot pair per screen

## Dependencies
- Depends on: TEST-004, LOC-003 (pseudo-locale)
- Blocks: —

## Definition of Done
- [ ] AC met, all top-30 screens covered, CI gate active
