# GOV-008: Terms Updates Re-Acceptance

**Epic**: GOV
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to be re-prompted when terms or privacy policy change materially
**So that** my consent stays current

## Acceptance Criteria

### AC-1: Detect new version
**Given** server publishes a new `consent_version`
**When** session bootstraps
**Then** the user sees a localized "Terms updated" gate before continuing

### AC-2: Show diff or full text
**Given** the gate is open
**When** user taps "What's changed"
**Then** localized changelog renders; or full text fallback

### AC-3: Decline → graceful sign out
**Given** user declines
**When** they confirm
**Then** session ends; localized message explains they may delete the account or contact support

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId in record
- [ ] Role gate: all
- [ ] Audit log on accept/decline

## Files
- `hogwarts/features/gov/views/terms-update-view.swift`
- `hogwarts/features/gov/viewmodels/terms-update-viewmodel.swift`
- `hogwarts/features/gov/services/consent-service.swift`

## API Contract
- `GET /api/mobile/consent/current` → `{ version, latest_version, changelog_url }`
- `POST /api/mobile/consent/:version` — accept

## i18n Keys
- `common.consent.terms_updated`, `whats_changed`, `decline_warning`

## Tests
- `HogwartsTests/gov/terms-reaccept-tests.swift`

## Dependencies
- Depends on: GOV-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged
