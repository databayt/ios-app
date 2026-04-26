# SUB-T-001: Teacher Absence Request

**Epic**: SUBSTITUTION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to request an absence with a reason and date range
**So that** colleagues can be notified to cover my classes

## Acceptance Criteria

### AC-1: Submit absence request
**Given** the teacher is on the substitution screen
**When** they enter date range + reason and tap "Submit"
**Then** request is POSTed with `school_id` and a confirmation appears

### AC-2: Validation error
**Given** end date is before start date
**When** they tap "Submit"
**Then** an inline localized error blocks submission

### AC-3: Notify colleagues
**Given** the request is accepted by backend
**When** the response returns
**Then** affected colleagues receive a push notification (server-side)

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate enforced server-side
- [ ] Role gate: teacher only
- [ ] Audit log on submit

## Files
- `hogwarts/features/substitution/views/absence-request-view.swift` — form
- `hogwarts/features/substitution/viewmodels/absence-request-viewmodel.swift` — state
- `hogwarts/features/substitution/services/substitution-service.swift` — API
- `hogwarts/features/substitution/models/absence-request.swift` — model

## API Contract
- `POST /api/mobile/teacher/absences` — `{ start_date, end_date, reason }` → `{ id, status }`

## i18n Keys
- `common.substitution.absence_request_title`
- `common.substitution.start_date`, `end_date`, `reason`
- `common.substitution.submit`

## Tests
- `HogwartsTests/substitution/absence-request-tests.swift`

## Dependencies
- Depends on: AUTH-006, CORE-001
- Blocks: SUB-T-002, SUB-T-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId verified, audit logged
