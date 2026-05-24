# PLT-X-004: Mac Catalyst Polish

**Epic**: F-PLATFORM-EXTENDED
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a Mac user, I want a polished Catalyst experience with sidebar, keyboard shortcuts, and menus, so that the app feels native on macOS.

## Acceptance Criteria
### AC-1: Sidebar layout
**Given** the app runs on macOS via Catalyst **When** opened **Then** NavigationSplitView shows sidebar persistent; supplementary + detail follow Mac conventions.

### AC-2: Keyboard shortcuts
**Given** the user presses ⌘K **When** triggered **Then** a command palette opens with localized actions (Open Dashboard, Search, etc.).

### AC-3: App menus
**Given** the menu bar **When** rendered **Then** menus are localized (File, Edit, View, Window, Help) with role-aware actions.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `home`)
- [ ] RTL-tested (per-app language)
- [ ] schoolId scope (per-feature)
- [ ] Role-gated menus
- [ ] Catalyst respects per-app language toggle
- [ ] Keyboard shortcuts localized

## Files
- `hogwarts/app/catalyst-menu-builder.swift` — UIMenu builder
- `hogwarts/app/command-palette-view.swift` — ⌘K
- `hogwarts/app/hogwarts-app.swift` — Catalyst flag

## API Contract
None.

## i18n Keys
- `common.menu.file`
- `common.menu.edit`
- `common.menu.view`
- `common.menu.window`
- `common.menu.help`
- `common.commandPalette.placeholder`

## Tests
- `HogwartsTests/catalyst/menu-builder-tests.swift`

## Dependencies
- Depends on: PLT-010
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
