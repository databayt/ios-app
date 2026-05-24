# TEST-002: MockAPIClient v2 with Fixtures Per Feature

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** a deterministic MockAPIClient with per-feature fixture folders
**So that** unit tests are fast and reproducible

## Acceptance Criteria

### AC-1: Pluggable fixture loader
**Given** a test specifies `feature: "fees"`
**When** MockAPIClient loads
**Then** JSON fixtures from `HogwartsTests/fixtures/fees/*.json` are mapped to endpoints

### AC-2: Override per test
**Given** a test wants to simulate 500
**When** test sets `client.override(.fees500)`
**Then** subsequent calls return that response

### AC-3: Multi-tenant fixtures
**Given** fixtures contain `school_id`
**When** loader scopes by `tenant`
**Then** isolation tests can swap tenants

## Cross-Cutting Invariants
- [ ] schoolId scoped in fixtures
- [ ] All M0 features have fixture folders

## Files
- `HogwartsTests/_harness/mock-api-client-v2.swift`
- `HogwartsTests/fixtures/<feature>/*.json` — per feature
- `HogwartsTests/_harness/fixture-loader.swift`

## API Contract
- (none — testing)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/_harness/mock-api-client-tests.swift`

## Dependencies
- Depends on: TEST-001
- Blocks: TEST-005, TEST-010

## Definition of Done
- [ ] AC met, fixtures for all M0 features, isolation supported
