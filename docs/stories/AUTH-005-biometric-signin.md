# AUTH-005: Biometric Sign-In (Face ID / Touch ID)

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## Decision Note (gap fill)
The existing `AUTH-004-school-selection.md` already covers school selection. The AUTH epic frontmatter still listed AUTH-005 as the missing "school selection" item — that's stale. Reviewing the existing AUTH-001..006 set (Google, Facebook, Email/Password, School Selection, Session Management), the obvious gap is **biometric sign-in**, which the epic's cross-cutting checks reference ("Biometric prompt localized") but no story owns. AUTH-005 fills that gap.

## User Story
As any user, I want to sign in with Face ID or Touch ID after first sign-in, so that subsequent launches are fast and secure without typing a password.

## Acceptance Criteria
### AC-1: Enable biometric prompt
**Given** the user has signed in once **When** session is established **Then** the app prompts to enable biometric unlock; on accept, a Keychain item is created with `LAPolicy.deviceOwnerAuthenticationWithBiometrics`.

### AC-2: Biometric unlock flow
**Given** biometric is enabled and the app launches **When** the user is on the unlock screen **Then** Face ID/Touch ID runs; on success, session is restored from Keychain without re-entering credentials.

### AC-3: Fallback to password
**Given** biometric fails 3 times or is unavailable **When** the user is denied **Then** the password sign-in screen appears with the email pre-filled.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`)
- [ ] RTL-tested
- [ ] schoolId scope (Keychain item key includes schoolId)
- [ ] Audit logged (auth.biometric.enabled, auth.biometric.success, auth.biometric.failed)

## Files
- `hogwarts/core/auth/biometric-service.swift` — LAContext wrapper
- `hogwarts/core/auth/keychain-service.swift` — biometric-bound storage
- `hogwarts/features/auth/views/biometric-unlock-view.swift` — UI
- `hogwarts/features/auth/viewmodels/biometric-prompt-view-model.swift` — flow

## API Contract
None — biometric is local; uses existing token refresh on unlock.

## i18n Keys
- `auth.biometric.prompt.title`
- `auth.biometric.prompt.reason`
- `auth.biometric.enable.title`
- `auth.biometric.enable.cta`
- `auth.biometric.failed.fallback`

## Tests
- `HogwartsTests/auth/biometric-service-tests.swift`
- Snapshot AR + EN, Face ID + Touch ID stub

## Dependencies
- Depends on: AUTH-006 (session)
- Blocks: AUTH-013 (offline grace period uses biometric)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
