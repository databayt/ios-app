# TT-008: Conflict Highlight (Teacher)

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want overlapping classes flagged in my schedule, so that I notice scheduling errors.

## Acceptance Criteria
### AC-1: Conflict pill
**Given** I have two classes overlapping **When** Week or Day view renders **Then** both cells show a red conflict pill.

### AC-2: Tap surfaces details
**Given** I tap a conflict pill **When** the sheet opens **Then** I see both classes side-by-side and a "Notify admin" button.

### AC-3: Cross-cutting
Pill text localized. RTL pill alignment. Audit log entry on notify.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged (notify)

## Files
- `hogwarts/features/timetable/views/conflict-pill.swift`
- `hogwarts/features/timetable/viewmodels/conflict-viewmodel.swift`
- `hogwarts/features/timetable/services/conflict-service.swift`

## API Contract
- (computed client-side from week response; server may also flag with `conflicts: bool`)
- `POST /api/mobile/timetable/conflicts/notify` — body `{ classIds: [a, b] }`

## i18n Keys
- `common.timetable.conflict`, `common.timetable.conflict_details`, `common.timetable.notify_admin`

## Tests
- `HogwartsTests/timetable/conflict-tests.swift`
- Conflict detection unit test

## Dependencies
- Depends on: TT-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
