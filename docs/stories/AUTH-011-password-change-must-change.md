# AUTH-011: Password Change (Must-Change-Password Flow)

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user, I want to change my password, including the forced "must change" flow on first login, so that I can keep my account secure.

## Acceptance Criteria
### AC-1: Voluntary change
**Given** Settings → Security → Change Password **When** user enters current + new + confirm **Then** the API validates and updates; success toast shown.

### AC-2: Must-change-password flow
**Given** the JWT carries a `must_change_password` claim (admin-issued temp password) **When** the user signs in **Then** the app routes them to a forced change screen; cannot dismiss until changed.

### AC-3: Strength validation
**Given** a new password **When** entered **Then** validation enforces min 8 chars, mixed case, digit, symbol; weak passwords show inline guidance.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (per-user)
- [ ] Audit logged (auth.password.changed, auth.password.mustChange.completed)

## Files
- `hogwarts/features/auth/views/change-password-view.swift` — UI
- `hogwarts/features/auth/views/must-change-password-view.swift` — forced UI
- `hogwarts/core/auth/auth-manager.swift` — change password
- `hogwarts/core/auth/auth-service.swift` — API

## API Contract
- `POST /api/mobile/auth/password-change` — `{ currentPassword, newPassword }`

## i18n Keys
- `auth.password.change.title`
- `auth.password.change.current`
- `auth.password.change.new`
- `auth.password.change.confirm`
- `auth.password.mustChange.title`
- `errors.password.weak`
- `errors.password.mismatch`

## Tests
- `HogwartsTests/auth/change-password-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
