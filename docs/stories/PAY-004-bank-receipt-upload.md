# PAY-004: Bank receipt upload (photo + verify)

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian (upload) or accountant (verify)
**I want** to upload a bank transfer receipt photo
**So that** the school can credit the invoice

## Acceptance Criteria

### AC-1: Guardian uploads
**Given** invoice **When** guardian taps "Upload bank receipt" **Then** photo capture/picker opens; uploaded with `invoice_id`, `amount`, `bank_ref`.

### AC-2: Accountant verifies
**Given** pending uploads **When** accountant opens queue **Then** they see preview; tap "Verify" → invoice updated, receipt issued; "Reject" → notify guardian.

### AC-3: Cross-cutting
**Given** image uploaded **When** stored **Then** key `<schoolId>:<invoiceId>:<uuid>`; audit logged on verify/reject.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `banking`)
- [ ] RTL-tested
- [ ] schoolId on POST + image key
- [ ] Currency from TenantContext
- [ ] Audit logged on verify/reject
- [ ] Role gate (guardian: upload; accountant: verify)

## Files
- `hogwarts/features/fees/views/bank-receipt-upload-view.swift` — guardian
- `hogwarts/features/fees/views/bank-receipt-verify-view.swift` — accountant queue
- `hogwarts/features/fees/services/payment-actions.swift` — `uploadBankReceipt`, `verifyBankReceipt`

## API Contract
- `POST /api/mobile/payments/bank-receipt` — multipart `{ invoice_id, amount, bank_ref, photo } → { id, status:"pending" }` (P0 backend)
- `GET /api/mobile/payments/bank-receipts?status=pending` — accountant queue
- `POST /api/mobile/payments/bank-receipts/:id/verify` / `:id/reject`

## i18n Keys
- `banking.bank_receipt.upload`
- `banking.bank_receipt.amount`
- `banking.bank_receipt.bank_ref`
- `banking.bank_receipt.verify`
- `banking.bank_receipt.reject`

## Tests
- `HogwartsTests/fees/bank-receipt-tests.swift`
- Role-gate test, multi-tenant isolation

## Dependencies
- Depends on: FEE-004
- Blocks: FEE-005, PAY-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
