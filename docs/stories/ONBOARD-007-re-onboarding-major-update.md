# ONBOARD-007: Re-Onboarding After Major Update

**Epic**: ONBOARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a returning user after a major version update, I want a brief "What's New" tour, so that I learn key new features without searching.

## Acceptance Criteria
### AC-1: Detect major-version change
**Given** the stored last-seen version is older than the bundle's MAJOR version **When** the app launches **Then** a "What's New" sheet appears once.

### AC-2: 3-card recap
**Given** the sheet is visible **When** rendered **Then** up to 3 cards highlight new features with localized title + body and a deep-link CTA.

### AC-3: Persist seen flag
**Given** the user dismisses **When** the sheet closes **Then** the lastSeenVersion is updated; will not re-show until next major bump.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`)
- [ ] RTL-tested
- [ ] schoolId scope (none)
- [ ] Tour visible only on first launch + after major version

## Files
- `hogwarts/features/onboarding/views/whats-new-sheet.swift` — sheet UI
- `hogwarts/core/preferences/app-version-tracker.swift` — comparison
- `hogwarts/app/hogwarts-app.swift` — gate present

## API Contract
None — content shipped with the build (or fetched via remote config in a later iteration).

## i18n Keys
- `onboarding.whatsNew.title`
- `onboarding.whatsNew.cta`
- `onboarding.whatsNew.dismiss`

## Tests
- `HogwartsTests/onboarding/whats-new-tests.swift`

## Dependencies
- Depends on: ONBOARD-003
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
