# FEE-002: Fee summary card

**Epic**: FEES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [guardian, student]
**Multi-Tenant**: required

## User Story
**As a** guardian or student
**I want** a summary card with total, paid, remaining
**So that** I see status at a glance

## Acceptance Criteria

### AC-1: Card renders
**Given** Fees screen **When** loaded **Then** card shows total assigned, total paid, remaining; uses `TenantContext.currency`.

### AC-2: Empty
**Given** no fees **When** card loads **Then** zero state with localized message.

### AC-3: Cross-cutting
**Given** guardian-multi-child **When** child selector switches **Then** summary updates for selected child only.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Currency from `TenantContext.currency`

## Files
- `hogwarts/features/fees/views/fee-summary-card-view.swift`
- `hogwarts/features/fees/viewmodels/fee-summary-viewmodel.swift`

## API Contract
- `GET /api/mobile/fees/summary/:student_id` — `{ total, paid, remaining, currency }`

## i18n Keys
- `finance.summary.total`
- `finance.summary.paid`
- `finance.summary.remaining`
- `finance.summary.empty`

## Tests
- `HogwartsTests/fees/fee-summary-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: FEE-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, currency from TenantContext verified
