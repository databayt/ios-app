# SET-003: Language Override

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to set the app language independent of system language, so that I can use Arabic UI on an English device or vice versa.

## Acceptance Criteria
### AC-1: Override takes effect immediately
**Given** I select Arabic from System=English **When** I tap Apply **Then** the app re-renders RTL within 1s without restart; language persists.

### AC-2: Reset to system
**Given** an override is active **When** I tap "Use System Language" **Then** the app follows OS locale on next launch.

### AC-3: Cross-cutting
Selecting `ar` flips layout to RTL. Number/date formatting follows the chosen locale. Push notification language updates.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested (after switching to ar)
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (all)
- [ ] Audit logged (preference)

## Files
- `hogwarts/features/settings/views/language-override-view.swift`
- `hogwarts/core/locale/locale-manager.swift`
- `hogwarts/core/locale/locale-storage.swift`

## API Contract
- `PUT /api/mobile/profile/locale` — body `{ locale }` (for push targeting)

## i18n Keys
- `profile.language.title`, `profile.language.system`, `profile.language.arabic`, `profile.language.english`, `profile.language.applied`

## Tests
- `HogwartsTests/settings/language-override-tests.swift`
- Snapshot AR + EN + light/dark; restart-not-required test

## Dependencies
- Depends on: SET-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved, no-restart toggle verified
