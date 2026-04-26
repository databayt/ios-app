# FEE-001: Fee list (assignments, balance)

**Epic**: FEES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [guardian, student]
**Multi-Tenant**: required

## User Story
**As a** guardian or student
**I want** a list of fee assignments with current balance per row
**So that** I see what's owed

## Acceptance Criteria

### AC-1: Renders fees
**Given** I am authenticated **When** I open Fees **Then** rows show fee name, due date, amount, paid, remaining; sorted by due date.

### AC-2: Tenant currency
**Given** school config currency = "SAR" **When** rendering amounts **Then** all amounts use `TenantContext.currency`, not device locale.

### AC-3: Cross-cutting
**Given** guardian with multiple children **When** child selector active (GRD-002) **Then** list filters by selected child id.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from `TenantContext.currency`
- [ ] Child filter (guardian)

## Files
- `hogwarts/features/fees/views/fee-list-view.swift`
- `hogwarts/features/fees/viewmodels/fee-list-viewmodel.swift`
- `hogwarts/features/fees/models/fee-model.swift` — `@Model` with `schoolId`, `studentId`

## API Contract
- `GET /api/mobile/fees?student_id=...` — `[ { id, name, due_at, amount, paid, currency } ]`

## i18n Keys
- `finance.fees.title`
- `finance.fees.due`
- `finance.fees.paid`
- `finance.fees.remaining`

## Tests
- `HogwartsTests/fees/fee-list-tests.swift`
- Currency formatter test

## Dependencies
- Depends on: AUTH-006, GRD-002
- Blocks: FEE-002, FEE-003, PAY-001

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, currency from TenantContext verified
