# SET-004: Theme Selection

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to choose Light, Dark, or System theme, so that the app matches my preference.

## Acceptance Criteria
### AC-1: Theme applies live
**Given** I am in Light mode **When** I select Dark **Then** the entire app re-renders with dark colors immediately and persists across launches.

### AC-2: System follows OS
**Given** I select System **When** OS toggles dark mode **Then** the app follows automatically.

### AC-3: Cross-cutting
RTL still correct in dark mode. Contrast meets WCAG AA in both themes.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/settings/views/theme-selection-view.swift`
- `hogwarts/core/theme/theme-manager.swift`

## API Contract
- (none — local pref)

## i18n Keys
- `profile.theme.title`, `profile.theme.light`, `profile.theme.dark`, `profile.theme.system`

## Tests
- `HogwartsTests/settings/theme-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: SET-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
