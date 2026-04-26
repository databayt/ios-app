# TT-006: Add to System Calendar

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student or teacher, I want to add a class to my iOS Calendar, so that I get system-level reminders.

## Acceptance Criteria
### AC-1: Single class export
**Given** I am on Class Detail **When** I tap "Add to Calendar" **Then** EventKit prompts; on permit, the event is created in my chosen calendar with correct timezone.

### AC-2: Permission denied path
**Given** Calendar permission is denied **When** I tap the action **Then** an explainer + Settings deep-link is shown.

### AC-3: Cross-cutting
Localized event title (entity.lang). RTL alert. Audit log entry on success.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (action sheet)
- [ ] schoolId predicate (n/a — local)
- [ ] Role-gated (student, teacher)
- [ ] Audit logged

## Files
- `hogwarts/features/timetable/services/calendar-export-service.swift`
- `hogwarts/features/timetable/views/class-detail-view.swift` — add action

## API Contract
- (none — uses EventKit locally; CORE-001 reference for telemetry)

## i18n Keys
- `common.timetable.add_to_calendar`, `common.timetable.calendar_permission_denied`, `common.timetable.added`

## Tests
- `HogwartsTests/timetable/add-to-calendar-tests.swift`
- EventKit mocked; permission flows

## Dependencies
- Depends on: TT-004, INT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
