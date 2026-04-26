# PLT-002: Medium Widget — Today's Schedule

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a medium widget that shows today's full schedule, so that I see all classes at a glance.

## Acceptance Criteria
### AC-1: Render schedule list
**Given** the medium widget is added **When** the timeline reloads **Then** up to 5 classes for today render with time + title + room.

### AC-2: Current class highlight
**Given** a class is in session **When** rendered **Then** that row is highlighted (color + leading bar).

### AC-3: Empty state
**Given** no classes today **When** rendered **Then** localized "No classes today" message appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (timeline filter)
- [ ] Role-gated
- [ ] Entity content rendered with `entity.lang`

## Files
- `HogwartsWidgets/todays-schedule-widget.swift` — Widget
- `HogwartsWidgets/todays-schedule-timeline-provider.swift` — TimelineProvider
- `hogwarts/core/data/widget-data-bridge.swift` — shared cache

## API Contract
None — widget reads SwiftData via App Group.

## i18n Keys
- `home.widget.todaysSchedule.title`
- `home.widget.todaysSchedule.empty`
- `home.widget.todaysSchedule.now`

## Tests
- `HogwartsWidgetsTests/todays-schedule-widget-tests.swift`
- Snapshot AR + EN, light + dark

## Dependencies
- Depends on: PLT-001
- Blocks: PLT-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
