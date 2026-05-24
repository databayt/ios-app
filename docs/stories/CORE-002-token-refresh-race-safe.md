# CORE-002: Race-Safe Token Refresh via PUT /mobile/auth

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** signed-in user
**I want** the app to refresh my token transparently when it expires
**So that** my session never breaks mid-action even with concurrent requests

## Acceptance Criteria

### AC-1: Transparent 401 retry
**Given** a request returns 401 with expired token **When** APIClient detects it **Then** it calls `PUT /api/mobile/auth` with `X-Refresh-Token`, receives a new JWT, and retries the original request once.

### AC-2: Single in-flight refresh
**Given** N concurrent requests all 401 simultaneously **When** refresh fires **Then** only ONE PUT /auth call goes out and all N requests await the same refreshed token.

### AC-3: Refresh failure forces sign-out
**Given** refresh returns 401 (refresh token expired) **When** the response is read **Then** TenantContext clears, KeychainService wipes, and the user is routed to login with localized message.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] schoolId predicate (TenantContext cleared on failure)
- [ ] Audit logged (sign-out event)

## Files
- `hogwarts/core/api/api-client.swift` — interceptor + actor-isolated refresh queue
- `hogwarts/core/auth/auth-manager.swift` — refresh entry point
- `hogwarts/core/auth/keychain-service.swift` — refresh token storage

## API Contract
- `PUT /api/mobile/auth` — header `X-Refresh-Token`; response `{ access_token, expires_in }`

## i18n Keys
- `errors.auth.session_expired`, `errors.auth.refresh_failed`

## Tests
- `HogwartsTests/core/auth/token-refresh-race-tests.swift` — concurrent 401 storm, single refresh assertion

## Dependencies
- Depends on: CORE-001
- Blocks: CORE-003, all authenticated features

## Definition of Done
- [ ] AC met, race test passes 100×, RTL screenshot of session-expired alert, parity preserved
