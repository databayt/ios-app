# SUB-S-004: Payment Method

**Epic**: SUBSCRIPTION-SAAS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As a** school admin
**I want** to manage the payment method on file
**So that** invoices charge the correct card

## Acceptance Criteria

### AC-1: View current method
**Given** a card is on file
**When** admin opens Payment Method
**Then** brand + last 4 + expiry render (no full number)

### AC-2: Update via Stripe sheet
**Given** admin taps "Change card"
**When** Stripe payment sheet opens
**Then** new method saves to backend; localized success toast

### AC-3: Remove method blocks subscription
**Given** admin removes the only method
**When** they confirm
**Then** localized warning that subscription will pause appears before removal

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `sales`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] Audit log per change
- [ ] No PAN stored client-side

## Files
- `hogwarts/features/subscription/views/payment-method-view.swift`
- `hogwarts/features/subscription/viewmodels/payment-method-viewmodel.swift`
- `hogwarts/features/subscription/services/payment-method-service.swift`

## API Contract
- `GET /api/mobile/subscription/payment-method` → `{ brand, last4, exp_month, exp_year }`
- `POST /api/mobile/subscription/payment-method` — `{ stripe_token }`
- `DELETE /api/mobile/subscription/payment-method`

## i18n Keys
- `sales.subscription.payment_method`, `change_card`, `remove`, `pause_warning`

## Tests
- `HogwartsTests/subscription/payment-method-tests.swift`

## Dependencies
- Depends on: SUB-S-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged, no PAN client-side
