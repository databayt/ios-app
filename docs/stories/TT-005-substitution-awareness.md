# TT-005: Substitution Awareness

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student or teacher, I want to see substitution markers in day/week views, so that I know if a class has a substitute or is cancelled.

## Acceptance Criteria
### AC-1: Visual indicator
**Given** a class is covered by a substitute **When** Day or Week view renders **Then** the cell shows a substitute pill with the new teacher's name.

### AC-2: Cancelled state
**Given** a class is cancelled **When** the cell renders **Then** it shows strikethrough + "Cancelled" pill.

### AC-3: Cross-cutting
Pill labels localized. RTL pill alignment. Substitute name in entity.lang. No duplicate fetch — substitution rolls into timetable response.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student, teacher)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/timetable/views/substitution-pill.swift`
- `hogwarts/features/timetable/models/timetable-entry-model.swift` — substitute fields

## API Contract
- (extends timetable response with `substitute?: { teacherName }, cancelled: bool`)

## i18n Keys
- `common.timetable.substitute`, `common.timetable.cancelled`

## Tests
- `HogwartsTests/timetable/substitution-tests.swift`
- Snapshot AR + EN per state

## Dependencies
- Depends on: TT-002, TT-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
