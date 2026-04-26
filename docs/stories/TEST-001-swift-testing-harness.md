# TEST-001: Swift Testing Migration Audit + Harness

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** Swift Testing as the unit harness with a documented migration path from XCTest
**So that** new tests use a modern framework

## Acceptance Criteria

### AC-1: Harness in place
**Given** `HogwartsTests` target
**When** Swift Testing is added
**Then** `@Suite`/`@Test` examples run; XCTest UI test target remains

### AC-2: Migration plan
**Given** existing XCTest unit tests
**When** audit runs
**Then** migration tracker (CSV in repo) lists each XCTest file with target framework

### AC-3: CI integration
**Given** PRs run tests
**When** CI executes
**Then** Swift Testing + XCTest both run and report

## Cross-Cutting Invariants
- [ ] schoolId predicate enforced in mock data setup
- [ ] Multi-tenant isolation harness available

## Files
- `HogwartsTests/_harness/swift-testing-bootstrap.swift`
- `HogwartsTests/_harness/test-config.swift`
- `docs/testing/migration-tracker.csv`

## API Contract
- (none — tooling)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/_harness/sanity-test.swift` — Swift Testing smoke

## Dependencies
- Depends on: —
- Blocks: TEST-002, TEST-004, TEST-005

## Definition of Done
- [ ] AC met, harness committed, CI green
