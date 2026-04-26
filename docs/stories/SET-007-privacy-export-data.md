# SET-007: Privacy — Export My Data

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to request a copy of my data, so that I can comply with personal data portability and Apple App Store requirements.

## Acceptance Criteria
### AC-1: Request enqueues export
**Given** I tap "Export my data" **When** I confirm **Then** a job is enqueued and the screen shows "Export requested — email within 24h".

### AC-2: Email delivery
**Given** the job completes **When** the user opens email **Then** there is a signed download link valid 7 days, JSON archive scoped to current schoolId.

### AC-3: Cross-cutting
Localized confirmation copy. Audit log entry. Rate-limit: max 1 export per 24h.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (export scoped to current tenant)
- [ ] Role-gated (own user)
- [ ] Audit logged

## Files
- `hogwarts/features/settings/views/export-data-view.swift`
- `hogwarts/features/settings/viewmodels/export-data-viewmodel.swift`
- `hogwarts/features/settings/services/account-service.swift`

## API Contract
- `POST /api/mobile/account/export` → `{ jobId, etaHours }`

## i18n Keys
- `profile.export.title`, `profile.export.confirm`, `profile.export.requested`, `profile.export.email_eta`, `profile.export.rate_limited`

## Tests
- `HogwartsTests/settings/export-data-tests.swift`
- Snapshot AR + EN + light/dark; rate-limit test

## Dependencies
- Depends on: SET-001, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved, App Review acceptable
