# FEE-003: Invoice list

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** a list of invoices
**So that** I can view billing history

## Acceptance Criteria

### AC-1: List
**Given** invoices exist **When** I open Invoices **Then** rows show number, date, amount, status; filter by status.

### AC-2: Role scope
**Given** guardian **When** list loads **Then** invoices scoped to my children; accountant sees school-wide.

### AC-3: Cross-cutting
**Given** amounts **When** rendered **Then** use `TenantContext.currency`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from TenantContext
- [ ] Role gate

## Files
- `hogwarts/features/fees/views/invoice-list-view.swift`
- `hogwarts/features/fees/viewmodels/invoice-list-viewmodel.swift`
- `hogwarts/features/fees/models/invoice-model.swift` — `@Model` with `schoolId`

## API Contract
- `GET /api/mobile/invoices?status=...` — `[ { id, number, issued_at, total, status, currency } ]` (NEW — backend P0)

## i18n Keys
- `finance.invoices.title`
- `finance.invoices.status.paid`
- `finance.invoices.status.unpaid`
- `finance.invoices.empty`

## Tests
- `HogwartsTests/fees/invoice-list-tests.swift`
- Role scope test

## Dependencies
- Depends on: AUTH-006, GRD-002
- Blocks: FEE-004, PAY-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role scope verified
