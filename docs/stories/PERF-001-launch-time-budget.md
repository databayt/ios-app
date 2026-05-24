# PERF-001: Launch Time Budget

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** the app to launch in under 1.5s cold and 0.4s warm
**So that** the app feels instant

## Acceptance Criteria

### AC-1: Cold launch ≤ 1.5s on iPhone 12
**Given** iPhone 12 baseline
**When** XCTApplicationLaunchMetric runs
**Then** average cold launch ≤ 1.5s

### AC-2: Warm launch ≤ 0.4s
**Given** warm launch
**When** measured
**Then** ≤ 0.4s

### AC-3: Pre-main minimization
**Given** pre-main hooks
**When** profiled
**Then** no synchronous I/O, no heavy SDK init

## Cross-Cutting Invariants
- [ ] Multi-tenant data hydration deferred

## Files
- `hogwarts/HogwartsApp.swift` — startup audit
- `hogwarts/core/bootstrap/*.swift` — defer non-critical

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/perf/launch-perf-tests.swift`

## Dependencies
- Depends on: TEST-011
- Blocks: SHIP-001

## Definition of Done
- [ ] AC met on iPhone 12 + iPad Air, baseline committed
