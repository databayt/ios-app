# INTENT-004: Mark Attendance Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want a Siri/Shortcuts intent "Mark attendance for <class>", so that I can launch the attendance flow with one phrase.

## Acceptance Criteria
### AC-1: Class parameter provider
**Given** the intent is configured **When** user invokes it **Then** an EntityQuery presents the teacher's assigned classes (current schoolId only).

### AC-2: Quick run
**Given** a class is provided **When** intent runs **Then** the app opens to the QR scan/attendance roster for that class.

### AC-3: Role guard
**Given** a non-teacher invokes the intent **When** it runs **Then** an "Insufficient permissions" dialog is shown.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId scope (class list)
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/core/intents/mark-attendance-intent.swift` — AppIntent
- `hogwarts/core/intents/class-entity.swift` — AppEntity
- `hogwarts/core/intents/class-entity-query.swift` — EntityQuery

## API Contract
None — uses existing attendance flow.

## i18n Keys
- `attendance.intent.mark.title`
- `attendance.intent.mark.parameter.class`
- `attendance.intent.mark.unauthorized`

## Tests
- `HogwartsTests/intents/mark-attendance-intent-tests.swift`
- Multi-tenant scope test

## Dependencies
- Depends on: INTENT-001
- Blocks: INTENT-009

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
