# PAY-001: Apple Pay (PassKit + Stripe)

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to pay with Apple Pay
**So that** I can settle fees in one tap

## Acceptance Criteria

### AC-1: Apple Pay sheet
**Given** invoice unpaid **When** I tap "Pay with Apple Pay" **Then** PassKit sheet opens with merchant config + amount in `TenantContext.currency`.

### AC-2: Authorization → Stripe
**Given** I authorize **When** token returned **Then** sent to backend `/payments/process`; on success show success screen + receipt id.

### AC-3: Failure
**Given** Stripe rejects **When** error returned **Then** localized error message; invoice remains unpaid.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested success/failure
- [ ] schoolId on POST
- [ ] Currency from `TenantContext.currency`
- [ ] Audit logged on success
- [ ] Role gate (guardian)

## Files
- `hogwarts/features/fees/views/apple-pay-button-view.swift`
- `hogwarts/features/fees/services/payment-actions.swift` — `processApplePay(...)`
- `hogwarts/core/payments/passkit-controller.swift`

## API Contract
- `POST /api/mobile/payments/process` — `{ invoice_id, method:"apple_pay", token, amount, currency } → { receipt_id, status }` (P0 backend)

## i18n Keys
- `banking.apple_pay.button`
- `banking.apple_pay.success`
- `banking.apple_pay.error_generic`

## Tests
- `HogwartsTests/fees/apple-pay-tests.swift`
- Stub Stripe success + failure

## Dependencies
- Depends on: FEE-004, AUTH-006
- Blocks: FEE-005, PAY-005

## Definition of Done
- [ ] AC met, tests pass, audit row exists, currency from TenantContext verified
