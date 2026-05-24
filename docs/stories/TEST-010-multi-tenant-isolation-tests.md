# TEST-010: Multi-Tenant Isolation Tests

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** automated tests that verify school A data never leaks to school B
**So that** tenant isolation is enforceable in CI

## Acceptance Criteria

### AC-1: Per-feature isolation tests
**Given** every mutating feature
**When** the test seeds tenant A and tenant B data and queries as B
**Then** only B rows return; A rows are absent

### AC-2: API guard verification
**Given** a request without `school_id`
**When** the mocked endpoint is hit
**Then** test asserts the client refuses to send and surfaces a coding error

### AC-3: Cross-tenant fail-fast
**Given** tenant switch
**When** cached SwiftData rows are queried
**Then** old tenant rows are inaccessible

## Cross-Cutting Invariants
- [ ] schoolId predicate verified for every feature
- [ ] Tenant switch clears caches
- [ ] Audit log scoping verified

## Files
- `HogwartsTests/_harness/multi-tenant-runner.swift`
- `HogwartsTests/<feature>/<feature>-isolation-tests.swift` (per feature)

## API Contract
- (uses MockAPIClient v2)

## i18n Keys
- (none)

## Tests
- One isolation test per feature with mutations

## Dependencies
- Depends on: TEST-002, TEST-003
- Blocks: —

## Definition of Done
- [ ] AC met, every feature has an isolation test, all green
