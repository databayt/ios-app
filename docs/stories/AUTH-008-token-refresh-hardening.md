# AUTH-008: Token Refresh Hardening (Race-Safe)

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want token refresh to be race-safe under load, so that 10+ concurrent requests don't trigger duplicate refreshes or 401 cascades.

## Acceptance Criteria
### AC-1: Single in-flight refresh
**Given** an expired token **When** N concurrent requests detect it **Then** only one refresh request is sent; all others await the same Task and use its result.

### AC-2: Failure cascade
**Given** the refresh fails (refresh token revoked) **When** detected **Then** all queued requests fail uniformly with a sign-out trigger; the user is routed to login with "Session expired".

### AC-3: Test under load
**Given** a test fires 10 concurrent requests with an expired token **When** the test runs **Then** exactly one refresh call hits the server.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (preserved across refresh)
- [ ] Audit logged (auth.refresh.success, auth.refresh.failed)

## Files
- `hogwarts/core/auth/token-refresh-coordinator.swift` — actor with single-flight Task
- `hogwarts/core/network/api-client.swift` — call coordinator on 401
- `hogwarts/core/auth/auth-manager.swift` — wire

## API Contract
- `POST /api/mobile/auth/refresh` — `{ refreshToken }`, returns `{ access, refresh }`

## i18n Keys
- `errors.session.expired`
- `errors.session.refreshFailed`

## Tests
- `HogwartsTests/auth/token-refresh-coordinator-tests.swift`
- Concurrency test with 10 parallel requests

## Dependencies
- Depends on: AUTH-006
- Blocks: AUTH-013

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
