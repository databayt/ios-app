# AUTH-014: Universal Links Auth Deep-Link (Invite, Reset)

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user, I want auth-related links (invite acceptance, password reset) sent via email to open in the app, so that I land in the right flow without copy-paste.

## Acceptance Criteria
### AC-1: AASA configured
**Given** the app's Associated Domains entitlement **When** a user taps `https://kingfahad.databayt.org/auth/...` **Then** iOS routes to the app (verified via Apple App Site Association at the domain root).

### AC-2: Invite path
**Given** a `/auth/invite?token=...&schoolId=...` link **When** opened **Then** the app shows the invite-accept flow pre-filled.

### AC-3: Reset path
**Given** a `/auth/reset?token=...` link **When** opened **Then** the app shows a "Set new password" form gated by the token.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (deep-link payload)
- [ ] Audit logged (auth.invite.opened, auth.reset.opened)

## Files
- `hogwarts/app/universal-link-router.swift` — routing
- `hogwarts/features/auth/views/invite-accept-view.swift` — invite UI
- `hogwarts/features/auth/views/reset-password-view.swift` — reset UI
- `hogwarts/Info.plist` — Associated Domains

## API Contract
- `GET /api/mobile/auth/invite/{token}` — verify
- `POST /api/mobile/auth/reset` — `{ token, newPassword }`

## i18n Keys
- `auth.invite.title`
- `auth.invite.accept`
- `auth.reset.title`
- `auth.reset.success`
- `errors.auth.tokenInvalid`

## Tests
- `HogwartsTests/auth/universal-link-router-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: SHR-001, SHR-004, AUTH-015

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
