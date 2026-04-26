# INT-002: Reminders for Assignment Due Dates

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
As a student/guardian, I want assignment due dates added to iOS Reminders, so that I get system-level alerts even when the app is closed.

## Acceptance Criteria
### AC-1: Create reminder
**Given** an assignment with due date **When** user taps "Add to Reminders" **Then** a Reminder is created with due 24h before, title `<assignment.title> — <school_name>`, and a deep-link in notes.

### AC-2: Permission flow
**Given** first-time access **When** EKEventStore requests authorization **Then** the rationale string explains "Track assignments alongside personal tasks".

### AC-3: Tenant clarity in shared device
**Given** user belongs to multiple schools **When** reminder is created **Then** title includes `school_name` to distinguish across tenants.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (school_name in title)
- [ ] Audit logged

## Files
- `hogwarts/core/integration/reminders-service.swift` — wrapper
- `hogwarts/features/assignments/views/assignment-detail-view.swift` — CTA
- `hogwarts/features/assignments/viewmodels/assignment-detail-view-model.swift` — link

## API Contract
None — local EventKit Reminders.

## i18n Keys
- `common.reminders.add`
- `common.reminders.added`
- `common.reminders.permissionDenied`
- `common.reminders.rationale`

## Tests
- `HogwartsTests/integration/reminders-service-tests.swift`
- Snapshot AR + EN, light + dark

## Dependencies
- Depends on: INT-001 (permission pattern)
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
