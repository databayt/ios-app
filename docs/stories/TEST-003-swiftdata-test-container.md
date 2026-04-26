# TEST-003: SwiftData Test Container (In-Memory)

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** an in-memory SwiftData container helper for tests
**So that** persistence tests are isolated and fast

## Acceptance Criteria

### AC-1: Helper API
**Given** test needs SwiftData
**When** test calls `TestContainer.makeInMemory()`
**Then** ModelContainer with `isStoredInMemoryOnly: true` is returned

### AC-2: Per-test isolation
**Given** parallel tests
**When** each creates a container
**Then** containers do not leak data between tests

### AC-3: Multi-tenant seed
**Given** test seeds two `schoolId` values
**When** queries run
**Then** scoped fetches return only matching tenant rows

## Cross-Cutting Invariants
- [ ] schoolId on every model
- [ ] Multi-tenant seeding supported

## Files
- `HogwartsTests/_harness/test-container.swift`
- `HogwartsTests/_harness/seed-helpers.swift`

## API Contract
- (none — testing)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/_harness/test-container-tests.swift`

## Dependencies
- Depends on: TEST-001
- Blocks: TEST-010

## Definition of Done
- [ ] AC met, isolation verified, seed helpers documented
