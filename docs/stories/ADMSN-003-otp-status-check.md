# ADMSN-003: OTP-Based Status Check

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent
**I want** to check application status via OTP without an account
**So that** I do not need credentials

## Acceptance Criteria

### AC-1: Request OTP
**Given** user enters phone or email + application ID
**When** they tap "Send OTP"
**Then** server sends OTP via SMS+email; localized confirmation appears

### AC-2: Verify and view status
**Given** OTP arrives
**When** user enters it
**Then** status renders (received / under review / accepted / rejected) localized

### AC-3: Rate limit
**Given** 3 failed OTP attempts
**When** user submits a 4th
**Then** localized lockout message; retry after cool-down

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: public
- [ ] Audit log on verify

## Files
- `hogwarts/features/admission/views/otp-status-view.swift`
- `hogwarts/features/admission/viewmodels/otp-status-viewmodel.swift`
- `hogwarts/features/admission/services/admission-service.swift`

## API Contract
- `POST /api/mobile/admission/otp/request` — `{ application_id, phone_or_email }`
- `POST /api/mobile/admission/otp/verify` — `{ otp, application_id }` → `{ status }`

## i18n Keys
- `common.admission.send_otp`, `enter_otp`, `otp_sent`
- `common.admission.status_received`, `under_review`, `accepted`, `rejected`
- `errors.otp_lockout`

## Tests
- `HogwartsTests/admission/otp-status-tests.swift`

## Dependencies
- Depends on: ADMSN-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, rate limit verified
