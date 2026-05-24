# PLT-003: Lock Screen Widget — Attendance Status

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student/guardian, I want a Lock Screen widget showing today's attendance status (present/absent/late), so that I see status without unlocking the phone.

## Acceptance Criteria
### AC-1: Lock Screen variants
**Given** the widget is added (.accessoryCircular and .accessoryRectangular) **When** rendered **Then** circular variant shows status icon, rectangular shows status + time of last check-in.

### AC-2: Tenant scope
**Given** timeline reload **When** running **Then** only current schoolId's attendance is read; status reflects only that tenant.

### AC-3: No data state
**Given** no record today **When** rendered **Then** "—" placeholder appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`, `home`)
- [ ] RTL-tested
- [ ] schoolId scope (timeline)
- [ ] Role-gated (student own; guardian children)
- [ ] StandBy uses high-contrast typography

## Files
- `HogwartsWidgets/attendance-status-widget.swift` — Widget
- `HogwartsWidgets/attendance-status-timeline-provider.swift` — provider
- `hogwarts/core/data/widget-data-bridge.swift` — shared cache

## API Contract
None — local cache.

## i18n Keys
- `home.widget.attendance.title`
- `home.widget.attendance.present`
- `home.widget.attendance.absent`
- `home.widget.attendance.late`

## Tests
- `HogwartsWidgetsTests/attendance-status-widget-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: PLT-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
