# INTENT-002: Today's Schedule Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a Siri intent for "today's schedule", so that I can get a voice readout of my classes.

## Acceptance Criteria
### AC-1: Read aloud
**Given** the user invokes "Today's schedule" **When** intent runs **Then** Siri reads class titles + times for today, using entity-language content.

### AC-2: No classes today
**Given** today has no classes **When** intent runs **Then** Siri says the localized "No classes today" message.

### AC-3: Open app affordance
**Given** the user taps the dialog after readout **When** the app opens **Then** the timetable view for today is shown.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (timetable scoped)
- [ ] Role-gated (student → own; teacher → assigned)
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/core/intents/todays-schedule-intent.swift` — AppIntent
- `hogwarts/core/intents/intent-data-provider.swift` — fetch helpers
- `hogwarts/features/timetable/services/timetable-service.swift` — used by intent

## API Contract
None — uses cached SwiftData; falls back to GET `/api/mobile/timetable?day=today`.

## i18n Keys
- `home.intent.schedule.title`
- `home.intent.schedule.empty`
- `home.intent.schedule.dialog`

## Tests
- `HogwartsTests/intents/todays-schedule-intent-tests.swift`

## Dependencies
- Depends on: INTENT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
