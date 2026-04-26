# PLT-005: Live Activity — Class in Session Timer

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a Live Activity that counts down the current class duration on the lock screen and Dynamic Island, so that I know how much time is left.

## Acceptance Criteria
### AC-1: Activity start
**Given** a class begins **When** detected (timetable + clock) **Then** an ActivityKit Live Activity is started with subject, room, end-time.

### AC-2: Dynamic Island
**Given** the Dynamic Island is supported **When** the activity is live **Then** compact + expanded states render with subject and remaining time.

### AC-3: End-of-class cleanup
**Given** end time is reached or user ends class **When** triggered **Then** the activity ends and remaining UI shows the class summary briefly.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (activity attributes carry tenant)
- [ ] Role-gated
- [ ] Live Activity respects entity content language

## Files
- `hogwarts/core/live-activities/class-timer-activity.swift` — ActivityAttributes
- `HogwartsWidgets/class-timer-live-activity.swift` — Live Activity widget
- `hogwarts/features/timetable/services/timetable-service.swift` — start/stop

## API Contract
None — local ActivityKit; remote push for updates optional (P2).

## i18n Keys
- `home.liveActivity.classTimer.subtitle`
- `home.liveActivity.classTimer.ending`

## Tests
- `HogwartsTests/live-activities/class-timer-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: PLT-006, PLT-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
