# EVT-005: Add to system Calendar

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to add an event to my iOS Calendar
**So that** I get system reminders

## Acceptance Criteria

### AC-1: Add
**Given** EVT-002 detail **When** I tap "Add to Calendar" **Then** EventKit prompt for permission; on granted, EKEvent created in default calendar.

### AC-2: Timezone
**Given** event in school timezone **When** added **Then** EKEvent uses school timezone; not device timezone.

### AC-3: Cross-cutting
**Given** EKEvent created **When** title rendered **Then** uses `event.lang`; description includes universal-link back.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested permission alert (system)
- [ ] schoolId in deep link inside EKEvent notes
- [ ] Entity content lang in title

## Files
- `hogwarts/features/events/services/calendar-import-service.swift` — EventKit
- `hogwarts/features/events/views/event-detail-view.swift` — button

## API Contract
- (no new endpoint)

## i18n Keys
- `common.events.add_to_calendar`
- `common.events.calendar_permission_denied`

## Tests
- `HogwartsTests/events/calendar-import-tests.swift`
- Timezone test

## Dependencies
- Depends on: EVT-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, school timezone verified
