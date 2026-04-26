# PAY-008: Scholarship application

**Epic**: FEES
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to apply for a scholarship
**So that** I can request financial aid for my child

## Acceptance Criteria

### AC-1: Form
**Given** Scholarships entry **When** I tap "Apply" **Then** form requests reason, expected aid %, supporting documents (photo upload).

### AC-2: Submit
**Given** form valid **When** I submit **Then** server stores application as `pending`; admin/accountant reviews via web.

### AC-3: Cross-cutting
**Given** uploaded documents **When** stored **Then** keyed `<schoolId>:<applicationId>:<uuid>`; audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `finance`)
- [ ] RTL-tested form
- [ ] schoolId on POST + asset key
- [ ] Audit logged
- [ ] Role gate (guardian)
- [ ] Form text in `app.language`; submitted record stores `lang`

## Files
- `hogwarts/features/fees/views/scholarship-apply-view.swift`
- `hogwarts/features/fees/viewmodels/scholarship-viewmodel.swift`
- `hogwarts/features/fees/services/scholarship-actions.swift`

## API Contract
- `POST /api/mobile/scholarships/apply` — multipart `{ child_id, reason, percent_request, lang, documents[] } → { id, status }` (P2 backend)
- `GET /api/mobile/scholarships` — `[ { id, status, decision } ]`

## i18n Keys
- `finance.scholarship.apply`
- `finance.scholarship.reason`
- `finance.scholarship.percent`
- `finance.scholarship.documents`
- `finance.scholarship.submit`

## Tests
- `HogwartsTests/fees/scholarship-tests.swift`

## Dependencies
- Depends on: GRD-002, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
