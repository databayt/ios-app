# SET-009: Diagnostics & Support Bundle

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to view recent logs and ping the API, so that support can diagnose issues from a generated bundle.

## Acceptance Criteria
### AC-1: Run ping
**Given** I tap "Ping" **When** the round-trip completes **Then** I see latency in ms and reachability status.

### AC-2: Generate bundle
**Given** I tap "Generate Support Bundle" **When** the file is built **Then** it includes app version, recent logs, and device class — but excludes PII (no names, no IDs, no tokens).

### AC-3: Share via system sheet
**Given** the bundle exists **When** I tap Share **Then** the system share sheet opens; user can airdrop, email, or save to Files.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (only user's own logs)
- [ ] Role-gated (all)
- [ ] Audit logged (bundle generation)

## Files
- `hogwarts/features/settings/views/diagnostics-view.swift`
- `hogwarts/features/settings/services/support-bundle-service.swift`
- `hogwarts/core/logging/log-redactor.swift`

## API Contract
- `GET /api/mobile/health/ping` → `{ ok, ts }`

## i18n Keys
- `profile.diagnostics.title`, `profile.diagnostics.ping`, `profile.diagnostics.bundle`, `profile.diagnostics.share`, `profile.diagnostics.no_pii`

## Tests
- `HogwartsTests/settings/diagnostics-tests.swift`
- PII redaction unit test

## Dependencies
- Depends on: SET-001
- Blocks: PROF-005 (help center attaches diagnostics)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, PII-free bundle verified, parity preserved
