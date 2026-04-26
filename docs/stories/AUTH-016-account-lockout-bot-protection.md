# AUTH-016: Account Lockout + Bot Protection UI

**Epic**: AUTH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user (and as the system), I want temporary account lockout and a bot-protection challenge after repeated failed sign-ins, so that brute-force attacks are slowed.

## Acceptance Criteria
### AC-1: Rate-limit signal
**Given** N failed sign-ins for an email **When** server returns 429 with `lockoutUntil` and `requiresChallenge: true` **Then** the UI shows countdown timer and a challenge widget (DeviceCheck attestation).

### AC-2: Cleared after lockout
**Given** the lockout window expires **When** user retries **Then** the form re-enables and submission proceeds normally.

### AC-3: Bot challenge fallback
**Given** the system requests a challenge **When** DeviceCheck/AppAttest is unavailable **Then** a localized fallback notice tells user to wait or contact support.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (lockout per-user, not per-tenant)
- [ ] Audit logged (auth.lockout.triggered, auth.lockout.cleared)

## Files
- `hogwarts/features/auth/views/login-view.swift` — lockout state
- `hogwarts/features/auth/services/bot-challenge-service.swift` — DeviceCheck/AppAttest
- `hogwarts/core/auth/auth-manager.swift` — handle 429

## API Contract
- 429 response shape: `{ lockoutUntil: ISO8601, requiresChallenge: bool, attemptsRemaining: int }`
- `POST /api/mobile/auth/lockout/challenge` — `{ attestation }`

## i18n Keys
- `auth.lockout.title`
- `auth.lockout.retryIn`
- `auth.lockout.challenge`
- `errors.auth.tooManyAttempts`

## Tests
- `HogwartsTests/auth/lockout-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: none (backend dep 🔴 `/api/mobile/auth/lockout`)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
