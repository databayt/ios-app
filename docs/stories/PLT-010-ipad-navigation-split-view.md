# PLT-010: iPad Layouts via NavigationSplitView

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any iPad user, I want a sidebar + detail layout via NavigationSplitView, so that I can navigate features without losing context.

## Acceptance Criteria
### AC-1: Three-column on iPad
**Given** the device is iPad **When** the app launches **Then** NavigationSplitView renders with sidebar (top-level), supplementary (list), detail (item).

### AC-2: Orientation rotation
**Given** the iPad rotates **When** between portrait/landscape **Then** column widths adjust without state loss.

### AC-3: RTL mirror
**Given** Arabic locale **When** rendered **Then** sidebar is on the trailing side; navigation animations reverse.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested (full mirror)
- [ ] schoolId scope (existing per-feature)
- [ ] Role-gated (sidebar items vary by role)

## Files
- `hogwarts/app/ipad-root-view.swift` — NavigationSplitView
- `hogwarts/app/sidebar-view.swift` — sidebar
- `hogwarts/app/hogwarts-app.swift` — UIDevice branching

## API Contract
None — UI restructure.

## i18n Keys
- `home.sidebar.dashboard`
- `home.sidebar.timetable`
- `home.sidebar.messages`
- `home.sidebar.profile`

## Tests
- `HogwartsTests/ipad/navigation-split-view-tests.swift`
- Snapshot AR + EN, portrait + landscape

## Dependencies
- Depends on: AUTH-006
- Blocks: PLT-X-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
