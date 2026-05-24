# ATT-T-009: Interventions List (Chronic Absentees)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [teacher, admin]
**Multi-Tenant**: required

## User Story
As a teacher or admin, I want a list of chronically absent students with one-tap follow-up, so that I can intervene early.

## Acceptance Criteria
### AC-1: Below-threshold list
**Given** I open Interventions **When** the list loads **Then** I see students with attendance <80% (configurable), sorted ascending.

### AC-2: Action chip per row
**Given** I tap a row **When** the action sheet appears **Then** I can: send a message, schedule a meeting, or log an intervention note.

### AC-3: Cross-cutting
Threshold from school config. RTL list. Names entity.lang. Audit logged for actions.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher, admin)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/interventions-list.swift`
- `hogwarts/features/attendance/viewmodels/interventions-viewmodel.swift`
- `hogwarts/features/attendance/services/interventions-service.swift`

## API Contract
- `GET /api/mobile/attendance/interventions?threshold=80` → `[{ studentId, name, pct }]`
- `POST /api/mobile/attendance/interventions/log` — body `{ studentId, type, note }`

## i18n Keys
- `attendance.interventions.title`, `attendance.interventions.threshold`, `attendance.interventions.log_note`, `attendance.interventions.message`

## Tests
- `HogwartsTests/attendance/interventions-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: ATT-002
- Blocks: ATT-T-010

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
