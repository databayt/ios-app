# ATT-T-005: Bluetooth Beacon Proximity Attendance

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want students' phones (running the app) to be detected via Bluetooth beacon when in classroom range, so that attendance is taken passively.

## Acceptance Criteria
### AC-1: Beacon range detection
**Given** I start "Beacon Mode" **When** student phones are in range **Then** they auto-mark Present; an in-progress list updates live.

### AC-2: Confirmation step
**Given** detection completes **When** I tap End **Then** I review the list and confirm; only then are marks committed server-side.

### AC-3: Cross-cutting
Bluetooth + Location permissions handled. RTL list. schoolId-scoped beacon UUID. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate (beacon UUID per tenant)
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/beacon-mode-view.swift`
- `hogwarts/features/attendance/services/beacon-attendance-service.swift`
- `hogwarts/core/bluetooth/beacon-manager.swift`

## API Contract
- `POST /api/mobile/attendance/beacon/session/start`
- `POST /api/mobile/attendance/beacon/session/commit` — body `{ sessionId, presentStudentIds }`

## i18n Keys
- `attendance.beacon.title`, `attendance.beacon.start`, `attendance.beacon.end`, `attendance.beacon.permission_required`

## Tests
- `HogwartsTests/attendance/beacon-tests.swift`
- Permission flow test

## Dependencies
- Depends on: ATT-T-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
