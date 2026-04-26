# PROF-007: Activity Log

**Epic**: PROFILE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to see my recent logins and active sessions, so that I can spot suspicious activity.

## Acceptance Criteria
### AC-1: Last 10 sessions
**Given** I open Activity Log **When** the list loads **Then** I see the 10 most recent logins with device, IP region, and timestamp.

### AC-2: Revoke session
**Given** I see an active session that's not me **When** I tap "Sign out this device" **Then** the JWT is revoked server-side and the row updates to "Signed out".

### AC-3: Cross-cutting
Dates locale-formatted. Sessions returned only for the signed-in user (no cross-tenant leakage).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `auth`)
- [ ] RTL-tested
- [ ] schoolId predicate (own user only)
- [ ] Role-gated (all)
- [ ] Audit logged (revoke)

## Files
- `hogwarts/features/profile/views/activity-log-view.swift`
- `hogwarts/features/profile/viewmodels/activity-log-viewmodel.swift`
- `hogwarts/features/profile/services/activity-log-service.swift`

## API Contract
- `GET /api/mobile/profile/activity` → `[{ id, device, ipRegion, at, current }]`
- `POST /api/mobile/profile/sessions/:id/revoke`

## i18n Keys
- `profile.activity.title`, `profile.activity.device`, `profile.activity.revoke`, `profile.activity.current`, `profile.activity.signed_out`

## Tests
- `HogwartsTests/profile/activity-log-tests.swift`
- Snapshot AR + EN + light/dark; revoke flow integration test

## Dependencies
- Depends on: AUTH-006, CORE-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
