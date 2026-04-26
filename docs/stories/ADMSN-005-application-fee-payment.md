# ADMSN-005: Application Fee Payment

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent
**I want** to pay the application fee via Apple Pay or card
**So that** my application is finalized

## Acceptance Criteria

### AC-1: Apple Pay path
**Given** user taps "Pay fee"
**When** Apple Pay sheet appears
**Then** payment processes; on success, application marked `fee_paid`

### AC-2: Card fallback
**Given** Apple Pay is unavailable
**When** user taps "Pay fee"
**Then** Stripe payment sheet renders for card entry; same outcome on success

### AC-3: Failure handling
**Given** payment fails (declined)
**When** Stripe returns error
**Then** localized message + retry CTA; application stays `fee_pending`

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: public
- [ ] Audit log on payment
- [ ] No PAN client-side

## Files
- `hogwarts/features/admission/views/fee-payment-view.swift`
- `hogwarts/features/admission/viewmodels/fee-payment-viewmodel.swift`
- `hogwarts/features/admission/services/payment-service.swift`

## API Contract
- `POST /api/mobile/admission/applications/:id/payment-intent` → `{ client_secret, amount, currency }`
- `POST /api/mobile/admission/applications/:id/payment-confirm` — `{ payment_intent_id }`

## i18n Keys
- `common.admission.pay_fee`, `apple_pay`, `card`, `payment_success`
- `errors.payment_declined`

## Tests
- `HogwartsTests/admission/fee-payment-tests.swift`

## Dependencies
- Depends on: ADMSN-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, Apple Pay verified, audit logged
