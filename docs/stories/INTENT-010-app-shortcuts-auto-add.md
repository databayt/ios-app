# INTENT-010: App Shortcuts Auto-Add to Spotlight

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want the app's intents to be auto-added to Spotlight and Shortcuts, so that I can run them without manual setup.

## Acceptance Criteria
### AC-1: AppShortcutsProvider declared
**Given** the app is installed **When** iOS indexes shortcuts **Then** AppShortcutsProvider exposes Open Dashboard, Today's Schedule, Open Messages, Mark Attendance (role-aware), Pay Fee (guardian).

### AC-2: Phrase localization
**Given** the OS locale is `ar` **When** Spotlight indexes **Then** Arabic phrases are advertised.

### AC-3: Tenant phrasing
**Given** TenantContext has currentSchoolName **When** dynamic shortcuts render **Then** the school's name appears in shortcut subtitles.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId scope (shortcut subtitles include school)
- [ ] Role-gated (provider filters per role)

## Files
- `hogwarts/core/intents/app-shortcuts-provider.swift` — provider
- `hogwarts/core/intents/intent-localization.swift` — phrase tables

## API Contract
None — local.

## i18n Keys
- `home.shortcuts.openDashboard.phrase`
- `home.shortcuts.todaysSchedule.phrase`
- `home.shortcuts.openMessages.phrase`

## Tests
- `HogwartsTests/intents/app-shortcuts-provider-tests.swift`

## Dependencies
- Depends on: INTENT-001..007
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
