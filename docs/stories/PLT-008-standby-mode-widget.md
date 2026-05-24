# PLT-008: StandBy Mode Widget Styling

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want StandBy-friendly widget styling, so that on a charging dock my widgets are readable from across the room.

## Acceptance Criteria
### AC-1: Increased contrast
**Given** a widget runs in StandBy **When** detected via `\.widgetRenderingMode == .vibrant` or `.fullColor` env **Then** typography upsizes; backgrounds use high-contrast tokens.

### AC-2: Night mode adapt
**Given** ambient light low **When** OS forces red-tinted display **Then** the widget remains legible (no full-color images that overpower).

### AC-3: Tenant identity preserved
**Given** widget renders in StandBy **When** condensed **Then** the school logo or initial remains visible.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (logo per tenant)
- [ ] StandBy uses high-contrast typography

## Files
- `HogwartsWidgets/standby-style-modifiers.swift` — view modifiers
- `HogwartsWidgets/next-class-widget.swift` — apply
- `HogwartsWidgets/todays-schedule-widget.swift` — apply

## API Contract
None.

## i18n Keys
- (uses existing widget keys)

## Tests
- `HogwartsWidgetsTests/standby-style-tests.swift`
- StandBy snapshots (vibrant + fullColor)

## Dependencies
- Depends on: PLT-001, PLT-002, PLT-003, PLT-004
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
