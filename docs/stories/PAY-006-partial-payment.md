# PAY-006: Partial payment

**Epic**: FEES
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** to pay a fraction of an invoice
**So that** I can split charges over time

## Acceptance Criteria

### AC-1: Custom amount
**Given** invoice with remaining `R` **When** I enter amount `A < R` **Then** payment processed; remaining = `R − A`.

### AC-2: Validation
**Given** `A > R` or `A ≤ 0` **When** submit **Then** localized validation error.

### AC-3: Cross-cutting
**Given** partial payment **When** completes **Then** receipt issued for `A`; invoice status `partial`; audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Currency from TenantContext
- [ ] Audit logged

## Files
- `hogwarts/features/fees/views/partial-payment-view.swift`
- `hogwarts/features/fees/services/payment-actions.swift` — accepts `amount`

## API Contract
- (extends PAY-001/002/003 with explicit `amount` ≤ remaining)

## i18n Keys
- `banking.partial.amount`
- `banking.partial.remaining`
- `banking.partial.validation_exceeds`

## Tests
- `HogwartsTests/fees/partial-payment-tests.swift`

## Dependencies
- Depends on: PAY-001, PAY-002, PAY-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
