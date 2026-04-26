# RC-006: Guardian Sign Report Card

**Epic**: REPORTCARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to acknowledge a report card with a signed confirmation
**So that** the school records that I have reviewed my child's results

## Acceptance Criteria

### AC-1: Sign action
**Given** an unsigned report card **When** the guardian taps Sign **Then** a confirmation modal shows full disclosure text and the guardian taps Confirm to record signature with timestamp + device + IP.

### AC-2: Signed state
**Given** the report card is already signed **When** opened **Then** the Sign button is replaced with a "Signed on <date>" label and an audit reference.

### AC-3: Cross-tenant block
**Given** a guardian opens a child's report card from another school **When** the request is made **Then** the server returns 403 and the client surfaces "Not authorized".

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (verify response payload schoolId matches)
- [ ] Role-gated to guardian
- [ ] Audit logged

## Files
- `hogwarts/features/reportcard/views/sign-report-card-view.swift`
- `hogwarts/features/reportcard/viewmodels/sign-viewmodel.swift`
- `hogwarts/features/reportcard/services/sign-service.swift`

## API Contract
- `POST /api/mobile/report-cards/:id/sign` — `{ device_id, accept_text }` → `{ signed_at, audit_id }`

## i18n Keys
- `results.reportcard.sign_cta`, `results.reportcard.sign_disclosure`, `results.reportcard.signed_at`

## Tests
- `HogwartsTests/reportcard/sign-tests.swift`
- Multi-tenant isolation
- Audit log assertion

## Dependencies
- Depends on: RC-002, CORE-006 (audit)
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
