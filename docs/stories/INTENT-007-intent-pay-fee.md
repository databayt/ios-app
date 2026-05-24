# INTENT-007: Pay Fee Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
As a guardian, I want a Siri/Shortcuts intent "Pay <child>'s fee", so that I can pay outstanding fees with Apple Pay in one flow.

## Acceptance Criteria
### AC-1: Outstanding fees
**Given** the guardian has children with outstanding fees in current schoolId **When** intent runs **Then** the user is prompted to pick a fee (parameter: studentFeeId).

### AC-2: Apple Pay
**Given** a fee is chosen **When** payment proceeds **Then** Apple Pay sheet opens, on confirm StoreKit 2 / payment provider charges and server records receipt.

### AC-3: Tenant + role guard
**Given** user is not a guardian or fee belongs to another school **When** intent runs **Then** it errors out with a clear localized message.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId scope (fee belongs to tenant)
- [ ] Role-gated (guardian only)
- [ ] Audit logged (payment.attempted, payment.completed)

## Files
- `hogwarts/core/intents/pay-fee-intent.swift` — AppIntent
- `hogwarts/core/intents/fee-entity.swift` — AppEntity
- `hogwarts/features/fees/services/payment-service.swift` — Apple Pay

## API Contract
- `POST /api/mobile/fees/{id}/pay` — `{ schoolId, paymentToken }`, returns `{ receiptId }`

## i18n Keys
- `finance.intent.payFee.title`
- `finance.intent.payFee.parameter.fee`
- `finance.intent.payFee.confirm`
- `finance.intent.payFee.success`
- `finance.intent.payFee.error`

## Tests
- `HogwartsTests/intents/pay-fee-intent-tests.swift`
- Multi-tenant payment isolation test

## Dependencies
- Depends on: INTENT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
