# ADMSN-006: Inquiry Form

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent
**I want** to send an inquiry without applying
**So that** I can ask questions before committing

## Acceptance Criteria

### AC-1: Submit inquiry
**Given** user fills name, contact, message
**When** they tap "Send"
**Then** inquiry POSTed and a localized confirmation appears

### AC-2: Validation
**Given** required fields missing
**When** tap Send
**Then** inline localized errors prevent submission

### AC-3: Spam guard
**Given** rapid repeat submissions
**When** server returns 429
**Then** localized "Try again later" message

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: public
- [ ] Server-side rate limit

## Files
- `hogwarts/features/admission/views/inquiry-form-view.swift`
- `hogwarts/features/admission/viewmodels/inquiry-viewmodel.swift`
- `hogwarts/features/admission/services/admission-service.swift`

## API Contract
- `POST /api/mobile/admission/inquiries` — `{ name, contact, message }` → `{ id }`

## i18n Keys
- `common.admission.inquiry_title`, `name`, `contact`, `message`, `send`
- `errors.rate_limited`

## Tests
- `HogwartsTests/admission/inquiry-form-tests.swift`

## Dependencies
- Depends on: CORE-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, rate limit handled
