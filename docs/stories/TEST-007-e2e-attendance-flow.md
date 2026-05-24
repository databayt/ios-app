# TEST-007: E2E Attendance Flow

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** an end-to-end XCUITest for the teacher attendance flow
**So that** regressions in the daily-use path are caught

## Acceptance Criteria

### AC-1: Mark attendance
**Given** signed-in teacher with assigned class
**When** they mark all students present
**Then** server confirms; row turns green

### AC-2: Bulk + single mix
**Given** 30 students
**When** teacher marks 25 present, 3 absent, 2 late
**Then** state reflects per-student

### AC-3: Offline queue + sync
**Given** offline mid-flow
**When** teacher submits
**Then** action queues; sync on reconnect; same outcome

## Cross-Cutting Invariants
- [ ] schoolId scoped
- [ ] Role gate: teacher
- [ ] Audit logged

## Files
- `HogwartsUITests/attendance/attendance-e2e-tests.swift`
- `HogwartsUITests/_helpers/attendance-helpers.swift`

## API Contract
- (uses MockAPIClient v2)

## i18n Keys
- (none)

## Tests
- 3 attendance paths

## Dependencies
- Depends on: TEST-005, ATTENDANCE epic
- Blocks: —

## Definition of Done
- [ ] AC met, all paths green, offline path verified
