# SEC-006: Token Rotation Policy

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** access tokens rotated frequently with race-safe refresh
**So that** stolen tokens have a short blast radius

## Acceptance Criteria

### AC-1: Short-lived access token
**Given** access token issued
**When** lifetime ≤ 15 minutes
**Then** auto-refresh kicks in before expiry

### AC-2: Refresh race-safe
**Given** parallel API calls during refresh
**When** they 401
**Then** all share a single refresh promise; no thundering herd

### AC-3: Forced rotation on tenant switch
**Given** the user switches tenant
**When** new context activates
**Then** access + refresh tokens are reissued and old ones are revoked

## Cross-Cutting Invariants
- [ ] Keychain-only storage
- [ ] Audit log on rotation

## Files
- `hogwarts/core/auth/token-manager.swift`
- `hogwarts/core/networking/auth-interceptor.swift`

## API Contract
- `POST /api/mobile/auth/refresh` — `{ refresh_token }` → `{ access, refresh, expires_in }`

## i18n Keys
- (none)

## Tests
- `HogwartsTests/security/token-rotation-tests.swift`

## Dependencies
- Depends on: CORE-002, AUTH-006
- Blocks: SEC-007

## Definition of Done
- [ ] AC met, race-safe verified, tenant switch resets tokens
