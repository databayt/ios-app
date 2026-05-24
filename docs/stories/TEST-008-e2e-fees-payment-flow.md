# TEST-008: E2E Fees + Payment Flow

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** an end-to-end XCUITest for the guardian fees + payment flow
**So that** payment regressions are caught before release

## Acceptance Criteria

### AC-1: View invoice and pay
**Given** guardian has an outstanding invoice
**When** they tap "Pay" and complete
**Then** invoice flips to paid

### AC-2: Apple Pay path
**Given** Apple Pay test mode
**When** Apple Pay sheet renders
**Then** test confirms purchase; backend mock returns success

### AC-3: Decline + retry
**Given** card decline
**When** retry with valid card
**Then** payment succeeds; only one charge logged server-side

## Cross-Cutting Invariants
- [ ] schoolId scoped
- [ ] Role gate: guardian
- [ ] Audit logged

## Files
- `HogwartsUITests/fees/fees-e2e-tests.swift`
- `HogwartsUITests/_helpers/payment-helpers.swift`

## API Contract
- (uses MockAPIClient v2 + Stripe test mode)

## i18n Keys
- (none)

## Tests
- 3 fees paths

## Dependencies
- Depends on: TEST-005, FEES epic
- Blocks: —

## Definition of Done
- [ ] AC met, all paths green, no double-charge
