# ONBOARD-006: Locale Picker on First Launch

**Epic**: ONBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a first-time user, I want to pick the app language (Arabic or English) before anything else, so that I see the welcome flow in my preferred language.

## Acceptance Criteria
### AC-1: First-launch picker
**Given** the app's first launch **When** the splash completes **Then** a 2-option locale picker (العربية / English) appears; default highlight is Arabic.

### AC-2: Persist + apply immediately
**Given** the user taps a language **When** the selection is made **Then** `AppLanguage` is set, `Locale.current` rebuilds, and the welcome carousel renders in that language with correct RTL/LTR.

### AC-3: Re-launchable from settings
**Given** Settings → Language **When** the user opens it **Then** they can change language at any time (not just first launch).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `onboarding`)
- [ ] RTL-tested
- [ ] schoolId scope (none — pre-auth)
- [ ] First launch defaults to Arabic; user can pick English

## Files
- `hogwarts/features/onboarding/views/locale-picker-view.swift` — UI
- `hogwarts/core/preferences/app-language-store.swift` — persistence
- `hogwarts/app/hogwarts-app.swift` — first-launch gate

## API Contract
None — local UserDefaults.

## i18n Keys
- `onboarding.locale.title`
- `onboarding.locale.arabic`
- `onboarding.locale.english`
- `onboarding.locale.continue`

## Tests
- `HogwartsTests/onboarding/locale-picker-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: none
- Blocks: ONBOARD-001

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
