# ONBOARD-002: Permission Priming with Rationale

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a first-time user, I want permission rationale before each iOS prompt, so that I understand WHY before deciding (notifications, photos, calendar, biometric).

## Acceptance Criteria
### AC-1: Rationale screen first
**Given** post-welcome (or post-login for biometric) **When** a permission is needed **Then** a rationale screen with localized title + body + benefits is shown; only after the user taps "Continue" is the OS prompt invoked.

### AC-2: Denial is graceful
**Given** the user denies a permission **When** they continue **Then** the app does not block; instead, the relevant feature shows a localized "Enable in Settings" call-to-action when first used.

### AC-3: Info.plist parity
**Given** the rationale **When** matched against Info.plist usage descriptions **Then** the strings are consistent (no mismatch between primer and OS dialog).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`)
- [ ] RTL-tested
- [ ] schoolId scope (none)
- [ ] Permission rationale matches `Info.plist` usage descriptions

## Files
- `hogwarts/features/onboarding/views/permission-primer-view.swift` — rationale UI
- `hogwarts/features/onboarding/services/permission-coordinator.swift` — flow
- `hogwarts/Info.plist` — usage descriptions

## API Contract
None.

## i18n Keys
- `onboarding.permission.notifications.title`
- `onboarding.permission.notifications.body`
- `onboarding.permission.photos.title`
- `onboarding.permission.photos.body`
- `onboarding.permission.calendar.title`
- `onboarding.permission.calendar.body`
- `onboarding.permission.biometric.title`
- `onboarding.permission.biometric.body`
- `onboarding.permission.continue`
- `onboarding.permission.notNow`

## Tests
- `HogwartsTests/onboarding/permission-primer-tests.swift`

## Dependencies
- Depends on: ONBOARD-001
- Blocks: ONBOARD-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
