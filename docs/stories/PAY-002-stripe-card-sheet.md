# PAY-002: Stripe card sheet

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to enter a card via Stripe SDK
**So that** I can pay when Apple Pay is unavailable

## Acceptance Criteria

### AC-1: Stripe sheet
**Given** I tap "Pay with card" **When** sheet opens **Then** Stripe PaymentSheet shown with amount in `TenantContext.currency`.

### AC-2: Tokenize → process
**Given** I enter valid card **When** confirm tapped **Then** PaymentSheet completes; backend creates Charge; success screen shown.

### AC-3: Failure
**Given** Stripe declines **When** error returned **Then** localized error; option to retry with different card.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Currency from TenantContext
- [ ] Audit logged on success
- [ ] Role gate (guardian)
- [ ] PCI: card data never enters our process

## Files
- `hogwarts/features/fees/views/stripe-card-sheet-view.swift`
- `hogwarts/features/fees/services/payment-actions.swift` — `processStripe(...)`
- `hogwarts/core/payments/stripe-controller.swift`

## API Contract
- `POST /api/mobile/payments/process` — `{ invoice_id, method:"card", payment_intent_id, amount, currency } → { receipt_id, status }`

## i18n Keys
- `banking.card.button`
- `banking.card.success`
- `banking.card.declined`
- `banking.card.retry`

## Tests
- `HogwartsTests/fees/stripe-card-tests.swift`

## Dependencies
- Depends on: FEE-004, AUTH-006
- Blocks: FEE-005, PAY-005

## Definition of Done
- [ ] AC met, tests pass, audit row exists, currency from TenantContext verified
