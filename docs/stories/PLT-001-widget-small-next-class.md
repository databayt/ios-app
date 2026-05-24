# PLT-001: Small Home Widget — Next Class

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a small home-screen widget that shows my next class, so that I can glance at the schedule from the home screen.

## Acceptance Criteria
### AC-1: Render next class
**Given** the widget is added **When** the timeline reloads **Then** it shows class title, room, time, and tenant logo (small variant).

### AC-2: Tenant scope in timeline
**Given** the timeline provider runs **When** building entries **Then** it reads from the shared App Group SwiftData and filters by current schoolId only.

### AC-3: Empty state
**Given** no upcoming class today **When** the widget renders **Then** localized "No more classes today" message appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (timeline filter)
- [ ] Role-gated (student own; teacher assigned)
- [ ] Entity content rendered with `entity.lang`

## Files
- `HogwartsWidgets/next-class-widget.swift` — Widget
- `HogwartsWidgets/next-class-timeline-provider.swift` — TimelineProvider
- `hogwarts/core/data/widget-data-bridge.swift` — App Group reader

## API Contract
None — widget reads SwiftData via App Group.

## i18n Keys
- `home.widget.nextClass.title`
- `home.widget.nextClass.empty`

## Tests
- `HogwartsWidgetsTests/next-class-widget-tests.swift`
- Multi-tenant timeline test

## Dependencies
- Depends on: AUTH-006
- Blocks: PLT-002, PLT-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
