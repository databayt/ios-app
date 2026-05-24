# FEE-005: Receipt list

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** a list of payment receipts
**So that** I can review or share proof of payment

## Acceptance Criteria

### AC-1: List
**Given** receipts exist **When** I open Receipts **Then** rows show number, date, amount, method; sorted desc.

### AC-2: Tap → PDF
**Given** I tap a row **When** detail opens **Then** receipt PDF rendered/shared.

### AC-3: Cross-cutting
**Given** amounts **When** rendered **Then** use `TenantContext.currency`; receipt body in entity content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from TenantContext
- [ ] Entity content lang for receipt PDF
- [ ] Role gate

## Files
- `hogwarts/features/fees/views/receipt-list-view.swift`
- `hogwarts/features/fees/viewmodels/receipt-list-viewmodel.swift`
- `hogwarts/features/fees/models/receipt-model.swift` — `@Model` with `schoolId`

## API Contract
- `GET /api/mobile/payments/receipts` — `[ { id, number, date, amount, method, currency, lang } ]`
- `GET /api/mobile/payments/receipts/:id/pdf` — binary PDF

## i18n Keys
- `finance.receipts.title`
- `finance.receipts.method`
- `finance.receipts.empty`

## Tests
- `HogwartsTests/fees/receipt-list-tests.swift`

## Dependencies
- Depends on: PAY-001 or PAY-003 or PAY-004
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, currency + content lang verified
