# TEST-005: UI Smoke Tests Per Critical Path

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** UI smoke tests for each critical path
**So that** primary user journeys never silently break

## Acceptance Criteria

### AC-1: Critical paths covered
**Given** the M0 critical paths (auth, home, attendance, grades, fees, messages)
**When** smoke runs
**Then** each launches the path and reaches the success state

### AC-2: Stable selectors
**Given** UI tests
**When** CI runs
**Then** all selectors use accessibility identifiers; no flaky text matching

### AC-3: Multi-tenant smoke
**Given** smoke runs against tenant A and tenant B
**When** completing the same path
**Then** no cross-tenant data appears

## Cross-Cutting Invariants
- [ ] schoolId scoped per tenant in tests
- [ ] Stable accessibilityIdentifiers

## Files
- `HogwartsUITests/smoke/critical-path-tests.swift`
- `HogwartsUITests/_helpers/launch-arguments.swift`

## API Contract
- (none — uses MockAPIClient v2)

## i18n Keys
- (none)

## Tests
- 6 critical-path smoke flows

## Dependencies
- Depends on: TEST-002
- Blocks: TEST-006, TEST-007, TEST-008

## Definition of Done
- [ ] AC met, 6 paths green, no flaky selectors
