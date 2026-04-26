# PLT-007: Live Activity — Hall Pass Active

**Epic**: F-PLATFORM-CORE
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a Live Activity while a hall pass is active, so that both teacher and student see remaining permitted time.

## Acceptance Criteria
### AC-1: Start activity on grant
**Given** a teacher grants a hall pass **When** approved **Then** a Live Activity starts on student's device with destination + expiry.

### AC-2: Auto-expire
**Given** the pass expires **When** the timer reaches zero **Then** the Live Activity transitions to "Expired — return to class" state.

### AC-3: Tenant scope
**Given** student belongs to multiple schools **When** activity runs **Then** the attributes carry schoolId; OS Focus filter respects tenant.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (attributes)
- [ ] Role-gated
- [ ] Audit logged (hallPass.granted, hallPass.expired)

## Files
- `hogwarts/core/live-activities/hall-pass-activity.swift` — ActivityAttributes
- `HogwartsWidgets/hall-pass-live-activity.swift` — Live Activity
- `hogwarts/features/attendance/services/hall-pass-service.swift` — start/end

## API Contract
- `POST /api/mobile/hall-pass` — `{ studentId, destination, durationMin }`
- `POST /api/mobile/hall-pass/{id}/end`

## i18n Keys
- `home.liveActivity.hallPass.title`
- `home.liveActivity.hallPass.expired`
- `home.liveActivity.hallPass.return`

## Tests
- `HogwartsTests/live-activities/hall-pass-tests.swift`

## Dependencies
- Depends on: PLT-005
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
