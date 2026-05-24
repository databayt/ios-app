# TEST-006: E2E Auth Flow (XCUITest)

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** an end-to-end XCUITest for the auth flow
**So that** sign-in regressions are caught before merge

## Acceptance Criteria

### AC-1: Email/password sign-in
**Given** known test creds
**When** user taps Sign In
**Then** test reaches the dashboard for that role/school

### AC-2: OAuth simulator path
**Given** Google OAuth in test mode
**When** flow runs
**Then** mock provider returns deterministic JWT

### AC-3: Multi-tenant
**Given** a user belongs to two schools
**When** they choose tenant B
**Then** dashboard renders tenant B context

## Cross-Cutting Invariants
- [ ] schoolId verified across paths
- [ ] Role gate verified

## Files
- `HogwartsUITests/auth/auth-e2e-tests.swift`
- `HogwartsUITests/_helpers/auth-helpers.swift`

## API Contract
- (uses MockAPIClient v2)

## i18n Keys
- (none)

## Tests
- 3 auth paths

## Dependencies
- Depends on: TEST-005, AUTH-001/AUTH-003
- Blocks: —

## Definition of Done
- [ ] AC met, all paths green, multi-tenant verified
