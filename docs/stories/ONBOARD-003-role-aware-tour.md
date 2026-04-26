# ONBOARD-003: Role-Aware Tour (4 Personas)

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian]
**Multi-Tenant**: required

## User Story
As a logged-in user, I want a quick tour of the app tailored to my role (student/teacher/guardian/admin), so that I see only the surfaces I'll use.

## Acceptance Criteria
### AC-1: Role detection drives tour
**Given** authentication completes **When** TenantContext role is known **Then** the appropriate tour deck is loaded (4 decks total, role-keyed).

### AC-2: 4 cards per role
**Given** a tour starts **When** the user advances **Then** 4 highlight cards appear with localized title, description, and "Got it" / "Next" actions.

### AC-3: Skip and remember
**Given** the user taps "Skip" or finishes **When** complete **Then** the tour-completed flag is persisted (per role) so it does not re-show.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`)
- [ ] RTL-tested
- [ ] schoolId scope (TenantContext required)
- [ ] Role-gated (deck per role)

## Files
- `hogwarts/features/onboarding/views/role-tour-view.swift` — UI
- `hogwarts/features/onboarding/data/tour-decks.swift` — content
- `hogwarts/core/preferences/tour-state.swift` — persistence

## API Contract
None.

## i18n Keys
- `onboarding.tour.student.card1.title`
- `onboarding.tour.teacher.card1.title`
- `onboarding.tour.guardian.card1.title`
- `onboarding.tour.admin.card1.title`
- (16 cards × title/body)

## Tests
- `HogwartsTests/onboarding/role-tour-tests.swift`
- Snapshot AR + EN per role

## Dependencies
- Depends on: ONBOARD-002, AUTH-006
- Blocks: ONBOARD-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
