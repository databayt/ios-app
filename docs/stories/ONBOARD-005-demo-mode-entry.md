# ONBOARD-005: Demo Mode Entry from Welcome

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a prospect, I want a "Try Demo" button in the welcome flow, so that I can evaluate the app without signing up.

## Acceptance Criteria
### AC-1: CTA in welcome
**Given** the welcome carousel **When** rendered **Then** a "Try Demo" link sits below "Get Started"; tap routes into demo bootstrap (AUTH-017).

### AC-2: Skip permission priming for demo
**Given** demo bootstrap **When** entering **Then** permission priming is bypassed (or deferred) since demo data is read-only and no notifications/biometric needed yet.

### AC-3: Banner persists in demo
**Given** the user is in demo **When** any screen loads **Then** a "Demo mode — sign up to act" banner is visible at the top.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`, `auth`)
- [ ] RTL-tested
- [ ] schoolId scope (demo schoolId)
- [ ] Audit logged (demo.entered.fromOnboarding)

## Files
- `hogwarts/features/onboarding/views/welcome-carousel-view.swift` — CTA
- `hogwarts/core/auth/demo-mode-service.swift` — bootstrap

## API Contract
- `POST /api/mobile/auth/demo` — see AUTH-017

## i18n Keys
- `onboarding.welcome.tryDemo`
- `onboarding.welcome.signIn`
- `auth.demo.banner` (shared)

## Tests
- `HogwartsTests/onboarding/demo-entry-tests.swift`

## Dependencies
- Depends on: ONBOARD-001, AUTH-017
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
