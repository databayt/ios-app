# SUB-T-002: Substitution Accept (Cover for Colleague)

**Epic**: SUBSTITUTION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to accept a colleague's absence and cover their class
**So that** students are not left unattended

## Acceptance Criteria

### AC-1: Accept open substitution
**Given** an open substitution request is visible
**When** the teacher taps "Accept"
**Then** the request transitions to `pending_admin_approval` and admin is notified

### AC-2: Already accepted
**Given** another teacher accepted first
**When** the teacher taps "Accept"
**Then** a localized "Already covered" toast appears and the row updates

### AC-3: Network failure
**Given** offline
**When** the teacher taps "Accept"
**Then** action queues with error feedback and retries on reconnect

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: teacher only
- [ ] Audit log per state transition

## Files
- `hogwarts/features/substitution/views/substitution-list-view.swift` — list
- `hogwarts/features/substitution/viewmodels/substitution-list-viewmodel.swift`
- `hogwarts/features/substitution/services/substitution-service.swift` — accept call

## API Contract
- `POST /api/mobile/teacher/substitutions/:id/accept` → `{ id, status }`

## i18n Keys
- `common.substitution.accept`
- `common.substitution.already_covered`
- `common.substitution.accept_success`

## Tests
- `HogwartsTests/substitution/substitution-accept-tests.swift`

## Dependencies
- Depends on: SUB-T-001
- Blocks: SUB-T-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged
