# GOV-001: Legal Consent Flow on First Login

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** first-time user (any role)
**I want** to be presented with TOS, Privacy, COPPA, and GDPR-K notices
**So that** my use of the app is legally compliant

## Acceptance Criteria

### AC-1: Consent gate (App Store Review)
**Given** a first-time login
**When** the session is established
**Then** consent flow renders before any feature; user CANNOT proceed without accepting — required for App Store guideline 5.1.1 (data collection requires user awareness/consent)

### AC-2: Versioned record
**Given** the user accepts
**When** consent is recorded
**Then** record includes `tenant_id`, `user_id`, `consent_version`, timestamp, device — server-side

### AC-3: Localization
**Given** user is on AR or EN
**When** consent loads
**Then** TOS/Privacy/COPPA/GDPR-K full text renders in app language

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId in consent record
- [ ] Role gate: all
- [ ] Audit log on accept
- [ ] App Store BLOCKER

## Files
- `hogwarts/features/gov/views/consent-flow-view.swift`
- `hogwarts/features/gov/viewmodels/consent-viewmodel.swift`
- `hogwarts/features/gov/services/consent-service.swift`
- `hogwarts/features/gov/models/consent-version.swift`

## API Contract
- `GET /api/mobile/consent` → `{ version, tos_url, privacy_url, coppa_url, gdpr_k_url }`
- `POST /api/mobile/consent/:version` — `{ accepted_at, device_info }`

## i18n Keys
- `common.consent.title`, `accept`, `tos`, `privacy`, `coppa`, `gdpr_k`
- `errors.consent_required`

## Tests
- `HogwartsTests/gov/consent-flow-tests.swift`
- App Store review submission verification

## Dependencies
- Depends on: AUTH-006
- Blocks: All M0 features (gates first login)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, App Store guideline 5.1.1 satisfied, audit logged
