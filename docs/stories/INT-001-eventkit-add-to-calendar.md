# INT-001: EventKit Add-to-Calendar

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student/guardian, I want to add timetable classes, exams, and events to my iOS Calendar, so that I see school schedule alongside personal events.

## Acceptance Criteria
### AC-1: Add to Calendar happy path
**Given** an event detail screen **When** user taps "Add to Calendar" **Then** EventKit permission is requested (first time) and event is created with title, location, start/end, and notes including `school_name`.

### AC-2: Permission denied
**Given** Calendar permission is denied **When** user taps "Add to Calendar" **Then** an alert explains how to enable in Settings, with a deep-link.

### AC-3: RTL + content language
**Given** entity language is `ar` **When** event is added **Then** the calendar event title renders in Arabic and the school_name suffix uses the same lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (event notes carry tenant)
- [ ] Audit logged (calendar_event.added)

## Files
- `hogwarts/core/integration/eventkit-service.swift` — wrapper
- `hogwarts/features/timetable/views/timetable-detail-view.swift` — add CTA
- `hogwarts/features/exams/views/exam-detail-view.swift` — add CTA
- `hogwarts/features/events/views/event-detail-view.swift` — add CTA

## API Contract
None — local EventKit only.

## i18n Keys
- `common.calendar.add`
- `common.calendar.added`
- `common.calendar.permissionDenied`
- `common.calendar.openSettings`

## Tests
- `HogwartsTests/integration/eventkit-service-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: INT-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
