# TEST-004: Snapshot Tests (Atoms + Key Screens)

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** snapshot tests for every atom and top 30 screens in light/dark/RTL
**So that** visual regressions are caught in CI

## Acceptance Criteria

### AC-1: Variants per snapshot
**Given** an atom or screen
**When** snapshot runs
**Then** outputs cover {light, dark} × {LTR, RTL} × {1x, 3x Dynamic Type}

### AC-2: CI gate
**Given** a PR changes pixels
**When** snapshot diff exceeds tolerance
**Then** PR is blocked with annotated diffs

### AC-3: Reference images committed
**Given** designer-approved baselines
**When** added
**Then** images live under `HogwartsTests/__snapshots__/` with stable filenames

## Cross-Cutting Invariants
- [ ] All atoms covered
- [ ] schoolId-scoped data in fixtures
- [ ] RTL is verified per screen

## Files
- `HogwartsTests/_harness/snapshot-runner.swift`
- `HogwartsTests/__snapshots__/` — references
- `HogwartsTests/atoms/*-snapshot-tests.swift`
- `HogwartsTests/screens/*-snapshot-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Per atom + per top-30 screen

## Dependencies
- Depends on: TEST-001, TEST-002
- Blocks: TEST-009

## Definition of Done
- [ ] AC met, coverage of atoms 100%, top 30 screens, RTL verified
