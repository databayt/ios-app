# SET-001: Settings Root

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want a grouped iOS-style settings landing screen, so that I can navigate to any preference predictably.

## Acceptance Criteria
### AC-1: Grouped sections render
**Given** I open Settings **When** the view appears **Then** I see grouped sections: Notifications, Language, Theme, Accessibility, Data, Privacy, Diagnostics — each with chevron disclosure.

### AC-2: Cross-cutting
RTL: chevron flips and rows align trailing. Section headers localized. Tap any row navigates to its sub-screen.

### AC-3: Search within settings
**Given** I type in the search field **When** results are computed **Then** matching settings rows are filtered live.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `notifications`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a — local UI)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/settings/views/settings-root-view.swift`
- `hogwarts/features/settings/views/settings-section-row.swift`

## API Contract
- (none — pure UI)

## i18n Keys
- `profile.settings.title`, `profile.settings.section.notifications`, `profile.settings.section.language`, `profile.settings.section.theme`, `profile.settings.search`

## Tests
- `HogwartsTests/settings/settings-root-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: —
- Blocks: SET-002..SET-009

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
