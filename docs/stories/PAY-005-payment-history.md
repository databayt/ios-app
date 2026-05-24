# PAY-005: Payment history

**Epic**: FEES
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** to see payment history with method + status
**So that** I can audit transactions

## Acceptance Criteria

### AC-1: List
**Given** payments exist **When** I open History **Then** rows show date, amount, method (Apple Pay/card/cash/bank), status; sortable.

### AC-2: Filters
**Given** list visible **When** I filter by method or status **Then** results scope.

### AC-3: Cross-cutting
**Given** amounts **When** rendered **Then** use `TenantContext.currency`; tenant scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`, `banking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from TenantContext
- [ ] Role scope (guardian: own + children; accountant: school-wide)

## Files
- `hogwarts/features/fees/views/payment-history-view.swift`
- `hogwarts/features/fees/viewmodels/payment-history-viewmodel.swift`

## API Contract
- `GET /api/mobile/payments/transactions?method=...&status=...` — `[ { id, date, amount, method, status, currency } ]` (P0 backend)

## i18n Keys
- `finance.history.title`
- `finance.history.filter.method`
- `finance.history.filter.status`
- `finance.history.empty`

## Tests
- `HogwartsTests/fees/payment-history-tests.swift`

## Dependencies
- Depends on: PAY-001, PAY-002, PAY-003, PAY-004
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role scope verified
