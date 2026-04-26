# SUB-S-003: Invoice History

**Epic**: SUBSCRIPTION-SAAS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As a** school admin
**I want** to view past invoices with PDF download
**So that** I have records for school accounting

## Acceptance Criteria

### AC-1: List invoices
**Given** the admin opens invoice history
**When** data loads
**Then** invoices render with date (localized), amount, status badge

### AC-2: Download PDF
**Given** an invoice row
**When** admin taps "Download"
**Then** PDF downloads with `.completeFileProtection` and shareable via ShareLink

### AC-3: Empty state
**Given** no invoices yet
**When** screen loads
**Then** localized empty state appears

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `sales`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] File data protection

## Files
- `hogwarts/features/subscription/views/invoice-history-view.swift`
- `hogwarts/features/subscription/viewmodels/invoice-history-viewmodel.swift`
- `hogwarts/features/subscription/services/invoice-service.swift`

## API Contract
- `GET /api/mobile/subscription/invoices` → `{ items: [{ id, date, amount, currency, pdf_url, status }] }`

## i18n Keys
- `sales.subscription.invoices`, `download`, `empty_invoices`, `paid`, `pending`

## Tests
- `HogwartsTests/subscription/invoice-history-tests.swift`

## Dependencies
- Depends on: SUB-S-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, file protection verified
