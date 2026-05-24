# GOV-002: Parental Consent for Minors

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian of a minor (under 13)
**I want** to grant explicit parental consent
**So that** the child can use the app per COPPA/GDPR-K

## Acceptance Criteria

### AC-1: Verifiable parental consent (App Store + COPPA)
**Given** a student under 13 signs in
**When** the consent gate evaluates
**Then** parent identity is verified (email + payment instrument confirmation OR signed declaration), required for App Store guideline 5.1.1(iii) and COPPA

### AC-2: Block child until consent
**Given** parental consent is missing
**When** child attempts any feature
**Then** child is blocked with a localized "Awaiting parental consent" screen

### AC-3: Consent record linked
**Given** parent consents
**When** record is created
**Then** record links `parent_user_id` ↔ `child_user_id` with version + timestamp

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId in record
- [ ] Role gate: minors only require parental consent
- [ ] Audit log on grant/revoke
- [ ] App Store BLOCKER (COPPA/GDPR-K)

## Files
- `hogwarts/features/gov/views/parental-consent-view.swift`
- `hogwarts/features/gov/viewmodels/parental-consent-viewmodel.swift`
- `hogwarts/features/gov/services/consent-service.swift`

## API Contract
- `GET /api/mobile/consent/parental/:childId` → `{ status, parent_id }`
- `POST /api/mobile/consent/parental/:childId/grant` — `{ proof }`

## i18n Keys
- `common.consent.parental_title`, `grant`, `awaiting_consent`, `verify_identity`

## Tests
- `HogwartsTests/gov/parental-consent-tests.swift`

## Dependencies
- Depends on: GOV-001
- Blocks: All minor-accessible features

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, COPPA satisfied, App Store guideline 5.1.1(iii) satisfied
