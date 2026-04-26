# SUB-T-003: Admin Approval

**Epic**: SUBSTITUTION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As an** admin
**I want** to approve or reject pending substitution requests
**So that** affected students/guardians are notified of the official substitute

## Acceptance Criteria

### AC-1: Approve substitution
**Given** a request is in `pending_admin_approval`
**When** admin taps "Approve"
**Then** request transitions to `approved` and notifications dispatch to students/guardians

### AC-2: Reject with reason
**Given** the admin taps "Reject"
**When** they enter a localized reason and confirm
**Then** request transitions to `rejected` and the substitute is unbooked

### AC-3: Permission gate
**Given** a non-admin user
**When** they navigate to the approval queue
**Then** access is denied with localized message

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] Audit log per approve/reject

## Files
- `hogwarts/features/substitution/views/admin-approval-view.swift`
- `hogwarts/features/substitution/viewmodels/admin-approval-viewmodel.swift`
- `hogwarts/features/substitution/services/substitution-service.swift` — approve/reject

## API Contract
- `POST /api/mobile/teacher/substitutions/:id/approve` → `{ id, status }`
- `POST /api/mobile/teacher/substitutions/:id/reject` — `{ reason }` → `{ id, status }`

## i18n Keys
- `common.substitution.approve`, `reject`, `reject_reason`
- `common.substitution.approval_success`

## Tests
- `HogwartsTests/substitution/admin-approval-tests.swift`

## Dependencies
- Depends on: SUB-T-002
- Blocks: SUB-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role gate verified, audit logged
