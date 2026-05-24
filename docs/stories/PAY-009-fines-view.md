# PAY-009: Fines view

**Epic**: FEES
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [guardian, accountant]
**Multi-Tenant**: required

## User Story
**As a** guardian or accountant
**I want** to see outstanding fines (library overdue, late fees)
**So that** I can settle them

## Acceptance Criteria

### AC-1: List
**Given** fines exist **When** I open Fines **Then** rows show reason, amount, due date; sorted desc.

### AC-2: Pay
**Given** fine **When** I tap "Pay" **Then** routed to PAY-001/002 with prefilled amount.

### AC-3: Cross-cutting
**Given** amounts **When** rendered **Then** use `TenantContext.currency`; descriptions in `entity.lang`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from TenantContext
- [ ] Entity content lang for reasons

## Files
- `hogwarts/features/fees/views/fines-view.swift`
- `hogwarts/features/fees/viewmodels/fines-viewmodel.swift`

## API Contract
- `GET /api/mobile/fines` — `[ { id, reason, lang, amount, due_at, status } ]`

## i18n Keys
- `finance.fines.title`
- `finance.fines.due`
- `finance.fines.pay`
- `finance.fines.empty`

## Tests
- `HogwartsTests/fees/fines-tests.swift`

## Dependencies
- Depends on: PAY-001, PAY-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, currency + content lang verified
