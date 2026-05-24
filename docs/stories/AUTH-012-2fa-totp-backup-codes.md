# AUTH-012: 2FA Setup (TOTP + Backup Codes)

**Epic**: AUTH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user, I want to enable two-factor authentication using TOTP and download backup codes, so that my account is harder to compromise.

## Acceptance Criteria
### AC-1: TOTP setup
**Given** Settings → Security → 2FA → Enable **When** the user opts in **Then** a QR code + secret is shown; user scans into Authenticator app and enters a 6-digit code to confirm.

### AC-2: Backup codes
**Given** TOTP is verified **When** complete **Then** 10 single-use backup codes are issued; the user is prompted to save them (Files share or copy).

### AC-3: 2FA challenge on login
**Given** 2FA is enabled **When** the user signs in **Then** a challenge screen requires the 6-digit code or a backup code before session is created.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (per-user)
- [ ] Audit logged (auth.2fa.enabled, auth.2fa.disabled, auth.2fa.challenge.failed)

## Files
- `hogwarts/features/auth/views/two-factor-setup-view.swift` — setup UI
- `hogwarts/features/auth/views/two-factor-challenge-view.swift` — sign-in challenge
- `hogwarts/features/auth/services/two-factor-service.swift` — API
- `hogwarts/core/auth/auth-manager.swift` — challenge state

## API Contract
- `POST /api/mobile/auth/2fa/enroll` — returns `{ secret, qrUrl, backupCodes[] }`
- `POST /api/mobile/auth/2fa/verify` — `{ code }`
- `POST /api/mobile/auth/2fa/challenge` — `{ code }` during sign-in

## i18n Keys
- `auth.2fa.title`
- `auth.2fa.scanQr`
- `auth.2fa.enterCode`
- `auth.2fa.backupCodes.title`
- `auth.2fa.backupCodes.saveWarning`
- `errors.2fa.invalidCode`

## Tests
- `HogwartsTests/auth/two-factor-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: none (verify backend at /api/mobile/auth/2fa/* — see epic backend deps 🟡)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
