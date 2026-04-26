# PAY-007: Refund flow

**Epic**: FEES
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [accountant]
**Multi-Tenant**: required

## User Story
**As an** accountant
**I want** to issue a refund against a paid invoice
**So that** I can correct overpayments or reverse charges

## Acceptance Criteria

### AC-1: Issue refund
**Given** paid invoice **When** I tap "Refund" and enter amount + reason **Then** server processes refund; invoice status updated.

### AC-2: Card vs cash routing
**Given** original method = card **When** refund issued **Then** Stripe refund via API; cash → manual receipt + audit only.

### AC-3: Cross-cutting
**Given** refund **When** completes **Then** audit `{ action:"payment.refund", original_receipt_id }`; guardian notified.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Currency from TenantContext
- [ ] Audit logged with reason
- [ ] Role gate (accountant only)

## Files
- `hogwarts/features/fees/views/refund-view.swift`
- `hogwarts/features/fees/services/payment-actions.swift` — `refund(...)`

## API Contract
- `POST /api/mobile/payments/refund` — `{ receipt_id, amount, reason } → { refund_id, status }` (P2 backend)

## i18n Keys
- `banking.refund.title`
- `banking.refund.amount`
- `banking.refund.reason`
- `banking.refund.confirm`

## Tests
- `HogwartsTests/fees/refund-tests.swift`
- Role-gate test, multi-tenant isolation

## Dependencies
- Depends on: PAY-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
