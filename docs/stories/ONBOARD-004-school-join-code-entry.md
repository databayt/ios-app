# ONBOARD-004: School Join Code Entry

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a new user, I want to enter my school's join code from onboarding, so that I land in the right tenant.

## Acceptance Criteria
### AC-1: Code entry UI
**Given** the user opts to "Join with code" from welcome **When** they enter a 6-char code **Then** the API validates and the school is bound to the next sign-up step.

### AC-2: Invalid code
**Given** an invalid code **When** submitted **Then** an inline error appears with localized guidance.

### AC-3: Pre-fill from universal link
**Given** the user opened the app via an invite link **When** the code-entry screen renders **Then** the code is pre-filled and validation runs automatically.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (resulting context)
- [ ] Audit logged (school.code.scanned)

## Files
- `hogwarts/features/onboarding/views/join-code-view.swift` — UI
- `hogwarts/features/onboarding/services/join-code-service.swift` — API
- `hogwarts/app/universal-link-router.swift` — pre-fill bridge

## API Contract
- `GET /api/mobile/schools/by-code/{code}` — returns `{ schoolId, schoolName, logoUrl }`

## i18n Keys
- `onboarding.joinCode.title`
- `onboarding.joinCode.placeholder`
- `onboarding.joinCode.cta`
- `errors.joinCode.invalid`

## Tests
- `HogwartsTests/onboarding/join-code-tests.swift`

## Dependencies
- Depends on: ONBOARD-001, AUTH-014
- Blocks: AUTH-015

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
