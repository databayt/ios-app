# HOME-006: Spotlight Quick-Actions

**Epic**: HOME
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want long-press app icon shortcuts (Spotlight quick-actions), so that I can jump into key flows without opening the app first.

## Acceptance Criteria
### AC-1: 4 quick actions visible
**Given** I long-press the app icon **When** the menu appears **Then** I see 4 role-appropriate quick actions (e.g., Mark Attendance, View Schedule, New Announcement, Search).

### AC-2: Action launches direct
**Given** I tap a quick action **When** the app opens **Then** it deep-links to the target screen, bypassing Home.

### AC-3: Cross-cutting
Localized via `Info.plist` per language. Role-aware list based on cached `currentRole`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`) via Localizable
- [ ] RTL-tested
- [ ] schoolId predicate (deep links carry context)
- [ ] Role-gated (defaults)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/Info.plist` — UIApplicationShortcutItems (or dynamic register)
- `hogwarts/core/spotlight/quick-actions-manager.swift`
- `hogwarts/HogwartsApp.swift` — handle shortcut launch

## API Contract
- (none)

## i18n Keys
- `home.quick.attendance`, `home.quick.schedule`, `home.quick.announce`, `home.quick.search`

## Tests
- `HogwartsTests/home/quick-actions-tests.swift`
- Deep-link launch test

## Dependencies
- Depends on: HOME-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
