# AUTH-013: Session Restore Polish + Offline Grace Period

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user, I want my session to restore quickly after relaunch, with a graceful offline period if the network is briefly unavailable, so that I am not blocked by short outages.

## Acceptance Criteria
### AC-1: Fast cold-start
**Given** a valid Keychain token at launch **When** the app starts **Then** the dashboard renders within 800ms (using cached SwiftData) while the token verification runs in the background.

### AC-2: Offline grace
**Given** the network is unreachable at launch **When** the cached token is < 24h since last verification **Then** the app proceeds offline; banner indicates "Offline" and read-only mode is enforced.

### AC-3: Force re-auth after expiry
**Given** > 7 days offline **When** the user reopens **Then** the app forces re-authentication regardless of cached token state.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (TenantContext from JWT)
- [ ] Audit logged (auth.offlineGrace.used)

## Files
- `hogwarts/core/auth/session-restore-service.swift` — bootstrap flow
- `hogwarts/core/auth/auth-manager.swift` — wire restore
- `hogwarts/core/network/connectivity-monitor.swift` — reachability
- `hogwarts/app/hogwarts-app.swift` — splash hand-off

## API Contract
None — uses existing `/auth/refresh`; offline path skips network.

## i18n Keys
- `auth.offline.banner`
- `auth.offline.readOnly`
- `auth.offline.forceReauth`

## Tests
- `HogwartsTests/auth/session-restore-tests.swift`
- Cold-start time benchmark

## Dependencies
- Depends on: AUTH-005, AUTH-006, AUTH-008
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
