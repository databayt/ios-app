# AUTH-007: Sign in with Apple

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want to sign in with my Apple ID, so that I can use the app without creating a password (and use "Hide My Email" if I prefer).

## Acceptance Criteria
### AC-1: Sign in with Apple button
**Given** the login screen **When** user taps "Sign in with Apple" **Then** ASAuthorizationAppleIDProvider sheet appears; on success, the app exchanges the identity token for a Hogwarts JWT.

### AC-2: Hide My Email
**Given** Apple returns a private relay email **When** account is created **Then** server stores the relay email; subsequent emails go via Apple's relay.

### AC-3: Account-not-registered
**Given** the Apple identity is not linked to a Hogwarts account **When** sign-in attempts **Then** an error explains contacting school administrator.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (post-sign-in TenantContext)
- [ ] Audit logged
- [ ] Apple sign-in respects Apple's "Hide My Email"

## Files
- `hogwarts/features/auth/services/apple-sign-in-service.swift` — ASAuthorization wrapper
- `hogwarts/features/auth/views/login-view.swift` — replace stub button
- `hogwarts/core/auth/auth-manager.swift` — signInWithApple

## API Contract
- `POST /api/mobile/auth/oauth/apple` — `{ identityToken, authorizationCode, fullName? }`, returns `{ access, refresh, user, schoolId? }`

## i18n Keys
- `auth.apple.signIn`
- `auth.apple.hideMyEmail`
- `errors.apple.notRegistered`
- `errors.apple.cancelled`

## Tests
- `HogwartsTests/auth/apple-sign-in-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
