# TEST-011: Performance Tests (XCTMetrics)

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** XCTMetrics-based perf tests on critical paths
**So that** regressions in launch, memory, scroll are caught early

## Acceptance Criteria

### AC-1: Launch metric
**Given** test target
**When** XCTApplicationLaunchMetric runs
**Then** cold launch budget enforced (≤1.5s on iPhone 12)

### AC-2: Scroll metric
**Given** top 5 lists
**When** XCTOSSignpostMetric runs
**Then** frame drops < threshold

### AC-3: Memory metric
**Given** memory metric
**When** test runs 30-min session
**Then** avg ≤ 150MB, max ≤ 300MB

## Cross-Cutting Invariants
- [ ] schoolId scoped data
- [ ] Multi-tenant seeded

## Files
- `HogwartsTests/perf/launch-perf-tests.swift`
- `HogwartsTests/perf/scroll-perf-tests.swift`
- `HogwartsTests/perf/memory-perf-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- 3 perf tests minimum

## Dependencies
- Depends on: TEST-002, PERF-001/002/003
- Blocks: —

## Definition of Done
- [ ] AC met, all 3 budgets enforced in CI, baseline committed
