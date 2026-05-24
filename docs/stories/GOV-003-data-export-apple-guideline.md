# GOV-003: Data Export

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to export all my personal data
**So that** I exercise my data portability rights

## Acceptance Criteria

### AC-1: In-app export request (App Store guideline 5.1.1(v))
**Given** the user is in Settings → Privacy
**When** they tap "Export My Data"
**Then** request is queued and a localized success message confirms — required for Apple Guideline 5.1.1(v) (data export must be in-app)

### AC-2: Email with download link in 24h
**Given** export request is queued
**When** server processes
**Then** within 24h the user receives a localized email with a time-limited download link

### AC-3: Re-auth required
**Given** the user taps "Export"
**When** they tap confirm
**Then** re-authentication is required before queuing

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (export scoped per tenant)
- [ ] Role gate: all
- [ ] Audit log on request
- [ ] App Store BLOCKER (5.1.1(v))

## Files
- `hogwarts/features/gov/views/data-export-view.swift`
- `hogwarts/features/gov/viewmodels/data-export-viewmodel.swift`
- `hogwarts/features/gov/services/data-export-service.swift`

## API Contract
- `POST /api/mobile/account/export` → `{ request_id, eta }`
- `GET /api/mobile/account/export/:id` → `{ status, download_url? }`

## i18n Keys
- `common.privacy.export_title`, `export`, `export_queued`, `re_auth_required`

## Tests
- `HogwartsTests/gov/data-export-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: SHIP-007 (App Review)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, Apple Guideline 5.1.1(v) satisfied, audit logged
