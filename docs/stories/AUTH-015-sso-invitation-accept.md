# AUTH-015: SSO Invitation Accept

**Epic**: AUTH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user invited by school email, I want to accept the invite and create an account, so that I can use the app with the school context pre-set.

## Acceptance Criteria
### AC-1: Token exchange
**Given** the invite universal link opens **When** the user lands on accept screen **Then** the token is exchanged with server; valid → user can pick OAuth or password sign-up; invalid → error.

### AC-2: School pre-binding
**Given** the invite carries schoolId **When** account is created **Then** TenantContext is populated with that school and user is added to its memberships.

### AC-3: Expired invite
**Given** the invite token is expired **When** opened **Then** an error explains contacting school admin for a new invite.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (set on accept)
- [ ] Audit logged (auth.invite.accepted)

## Files
- `hogwarts/features/auth/views/invite-accept-view.swift` — UI
- `hogwarts/features/auth/services/invite-service.swift` — API
- `hogwarts/core/auth/auth-manager.swift` — wire

## API Contract
- `POST /api/mobile/auth/invite/accept` — `{ token, ...credentials }`, returns `{ access, refresh, schoolId, user }`

## i18n Keys
- `auth.invite.welcome`
- `auth.invite.cta.signUp`
- `auth.invite.cta.signIn`
- `errors.auth.inviteExpired`

## Tests
- `HogwartsTests/auth/invite-accept-tests.swift`

## Dependencies
- Depends on: AUTH-014
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
