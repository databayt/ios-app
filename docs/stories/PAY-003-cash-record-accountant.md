# PAY-003: Cash record (accountant)

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [accountant]
**Multi-Tenant**: required

## User Story
**As an** accountant
**I want** to record a cash payment against an invoice
**So that** the system reflects collection at the front desk

## Acceptance Criteria

### AC-1: Record
**Given** invoice **When** I tap "Record cash" and enter amount + payer note **Then** invoice updated; receipt issued.

### AC-2: Validation
**Given** amount > remaining **When** confirm **Then** localized error.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** `school_id` enforced; audit `{ action:"payment.cash", actor:accountant_id }`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Currency from TenantContext
- [ ] Audit logged
- [ ] Role gate (accountant only)

## Files
- `hogwarts/features/fees/views/cash-record-view.swift`
- `hogwarts/features/fees/viewmodels/cash-record-viewmodel.swift`
- `hogwarts/features/fees/services/payment-actions.swift` — `recordCash(...)`

## API Contract
- `POST /api/mobile/payments/cash` — `{ invoice_id, amount, payer_name, note? } → { receipt_id, status }` (P0 backend)

## i18n Keys
- `banking.cash.title`
- `banking.cash.amount`
- `banking.cash.payer_name`
- `banking.cash.note`
- `banking.cash.confirm`

## Tests
- `HogwartsTests/fees/cash-record-tests.swift`
- Role-gate test

## Dependencies
- Depends on: FEE-004
- Blocks: FEE-005, PAY-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
