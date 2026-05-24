# FEE-004: Invoice detail with line items

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** invoice detail with line items
**So that** I understand what each charge is for

## Acceptance Criteria

### AC-1: Line items
**Given** I tap an invoice **When** detail loads **Then** I see header (issued, due, status) + line items (description, qty, unit, total); subtotal, tax, total at bottom.

### AC-2: PDF download
**Given** detail visible **When** I tap "Download PDF" **Then** server streams PDF; saved to Files / share sheet.

### AC-3: Cross-cutting
**Given** descriptions in entity content lang **When** rendering **Then** font + direction follow `invoice.lang`; currency = `TenantContext.currency`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from TenantContext
- [ ] Entity content lang
- [ ] Role gate

## Files
- `hogwarts/features/fees/views/invoice-detail-view.swift`
- `hogwarts/features/fees/viewmodels/invoice-detail-viewmodel.swift`
- `hogwarts/features/fees/services/invoice-actions.swift` — `downloadPDF(id)`

## API Contract
- `GET /api/mobile/invoices/:id` — `{ id, number, lang, line_items[], subtotal, tax, total, currency }` (P0 backend)
- `GET /api/mobile/invoices/:id/pdf` — binary PDF

## i18n Keys
- `finance.invoice.line_items`
- `finance.invoice.subtotal`
- `finance.invoice.tax`
- `finance.invoice.total`
- `finance.invoice.download_pdf`

## Tests
- `HogwartsTests/fees/invoice-detail-tests.swift`
- PDF download test

## Dependencies
- Depends on: FEE-003
- Blocks: PAY-001, PAY-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, currency + content lang verified
