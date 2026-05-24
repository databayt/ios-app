# ONBOARD-001: Hero/Welcome Carousel

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a first-time user, I want a 3-screen welcome carousel that introduces the app, so that I understand its value before signing in.

## Acceptance Criteria
### AC-1: Three screens
**Given** first launch (post locale picker) **When** the welcome screen renders **Then** 3 paged screens (Stay informed / Manage your day / Connect with school) are shown with title, subtitle, illustration, page-control.

### AC-2: RTL reverse
**Given** Arabic locale **When** the user swipes **Then** swipe direction reverses (page 1 is on trailing side).

### AC-3: Skip + complete
**Given** any screen **When** user taps "Skip" or completes the last screen **Then** they advance to AUTH/locale flow; the welcome flag is persisted.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`)
- [ ] RTL-tested (reversed scroll)
- [ ] schoolId scope (none — pre-auth)
- [ ] First launch defaults to Arabic; user can pick English

## Files
- `hogwarts/features/onboarding/views/welcome-carousel-view.swift` — TabView/PageView
- `hogwarts/features/onboarding/viewmodels/welcome-carousel-view-model.swift` — state
- `hogwarts/core/preferences/onboarding-state.swift` — persistence

## API Contract
None.

## i18n Keys
- `onboarding.welcome.page1.title`
- `onboarding.welcome.page1.subtitle`
- `onboarding.welcome.page2.title`
- `onboarding.welcome.page2.subtitle`
- `onboarding.welcome.page3.title`
- `onboarding.welcome.page3.subtitle`
- `onboarding.welcome.skip`
- `onboarding.welcome.next`
- `onboarding.welcome.start`

## Tests
- `HogwartsTests/onboarding/welcome-carousel-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: ONBOARD-006
- Blocks: ONBOARD-002, ONBOARD-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
