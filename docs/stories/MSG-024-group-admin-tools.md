# MSG-024: Group Admin Tools (Add/Remove, Role)

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** group admin
**I want** to add/remove members and promote/demote roles
**So that** I can manage the group's composition

## Acceptance Criteria

### AC-1: Add members
**Given** an admin opens the group's info **When** they tap Add Members **Then** the directory picker opens scoped to the school; tapping confirm adds them.

### AC-2: Remove
**Given** an admin swipes a member **When** they tap Remove **Then** a confirmation alert fires; on confirm the member is removed and a system message posts.

### AC-3: Promote/demote
**Given** an admin taps a member **When** they tap "Make Admin" or "Demote" **Then** the role updates server-side and badges refresh for all participants.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate (only same-school)
- [ ] Role-gated to group admin
- [ ] Audit logged for every admin action

## Files
- `hogwarts/features/messaging/views/group-admin-view.swift`
- `hogwarts/features/messaging/services/group-admin-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/members` — `{ user_id }`
- `DELETE /api/mobile/conversations/:id/members/:user_id`
- `POST /api/mobile/conversations/:id/members/:user_id/role` — `{ role }`

## i18n Keys
- `messaging.group.add_member`, `messaging.group.remove`, `messaging.group.make_admin`, `messaging.group.demote`

## Tests
- `HogwartsTests/messaging/group-admin-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: MSG-023
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
