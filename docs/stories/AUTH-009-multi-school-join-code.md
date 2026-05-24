# AUTH-009: Multi-School Join Code Flow

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a user with multiple schools, I want to join an additional school via a join code, so that I can access more than one tenant from the same account.

## Acceptance Criteria
### AC-1: Enter code
**Given** the user is signed in **When** they tap "Join another school" and enter a 6-char code **Then** the server validates and adds the school membership.

### AC-2: Switch context after join
**Given** a successful join **When** completed **Then** the school selection screen reappears with the new school listed; selecting it switches TenantContext.

### AC-3: Invalid code
**Given** an invalid or expired code **When** submitted **Then** an inline error appears (no membership change).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (memberships table)
- [ ] Audit logged (school.joined)

## Files
- `hogwarts/features/auth/views/join-school-view.swift` — code entry
- `hogwarts/features/auth/services/join-school-service.swift` — API
- `hogwarts/features/auth/views/school-selection-view.swift` — refresh list

## API Contract
- `POST /api/mobile/schools/join` — `{ code }`, returns `{ schoolId, schoolName }`

## i18n Keys
- `auth.joinSchool.title`
- `auth.joinSchool.code.placeholder`
- `auth.joinSchool.cta`
- `errors.joinSchool.invalidCode`
- `errors.joinSchool.expired`

## Tests
- `HogwartsTests/auth/join-school-service-tests.swift`

## Dependencies
- Depends on: AUTH-004, AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
