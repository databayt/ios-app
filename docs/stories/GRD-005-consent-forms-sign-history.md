# GRD-005: Consent forms (sign + history)

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to sign consent forms and see history
**So that** I authorize school activities

## Acceptance Criteria

### AC-1: List pending
**Given** pending consents exist **When** I open Consent **Then** rows show child, form title, due_at; sorted by urgency.

### AC-2: Sign
**Given** form open **When** I review and tap "Sign" **Then** server records signature with timestamp + device + IP.

### AC-3: Cross-cutting
**Given** form body in `form.lang` **When** rendering **Then** font + direction respected; signed copies stored per `<schoolId>:<childId>:<formId>`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId + childId on POST
- [ ] Audit logged with device fingerprint
- [ ] Role gate (guardian only)
- [ ] Entity content lang for form body

## Files
- `hogwarts/features/guardian/views/consent-list-view.swift`
- `hogwarts/features/guardian/views/consent-detail-view.swift`
- `hogwarts/features/guardian/viewmodels/consent-viewmodel.swift`
- `hogwarts/features/guardian/services/guardian-actions.swift` — `signConsent`

## API Contract
- `GET /api/mobile/guardian/consent` — `[ { id, child_id, title, body, lang, due_at, signed_at? } ]` (P1 backend)
- `POST /api/mobile/guardian/consent/:id` — `{ device_id } → { signed_at }`

## i18n Keys
- `profile.consent.title`
- `profile.consent.due`
- `profile.consent.sign`
- `profile.consent.history`

## Tests
- `HogwartsTests/guardian/consent-tests.swift`
- Audit fingerprint test, multi-tenant isolation

## Dependencies
- Depends on: GRD-001
- Blocks: GRD-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists with device fingerprint
