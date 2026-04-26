# AUTH-010: Logout on All Devices

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user, I want to log out of all devices in case I lose my phone, so that I can revoke access remotely.

## Acceptance Criteria
### AC-1: Trigger from settings
**Given** the user is in Settings → Security **When** they tap "Log out of all devices" **Then** a confirmation alert appears.

### AC-2: Server revokes all refresh tokens
**Given** the user confirms **When** the API completes **Then** all refresh tokens for the user are revoked; current session also terminates.

### AC-3: Other devices route to login on next request
**Given** another device makes any API call after revocation **When** the 401 is returned **Then** the device routes to login with "Session expired".

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`)
- [ ] RTL-tested
- [ ] schoolId scope (per-user; affects all tenants user is in)
- [ ] Audit logged (auth.logoutAllDevices)

## Files
- `hogwarts/features/settings/views/security-settings-view.swift` — CTA
- `hogwarts/core/auth/auth-manager.swift` — logoutAll
- `hogwarts/core/auth/auth-service.swift` — API

## API Contract
- `POST /api/mobile/auth/logout-all` — returns `{ revokedCount }`

## i18n Keys
- `auth.logoutAll.title`
- `auth.logoutAll.confirm`
- `auth.logoutAll.success`

## Tests
- `HogwartsTests/auth/logout-all-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
