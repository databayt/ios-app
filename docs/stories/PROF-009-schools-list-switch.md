# PROF-009: Schools List + Add/Switch

**Epic**: PROFILE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a multi-school user, I want to see all my schools and switch active tenant, so that I can operate in the correct context.

## Acceptance Criteria
### AC-1: List + switch
**Given** I belong to 2+ schools **When** I open Schools **Then** I see all schools and active marker; tapping a different one switches `TenantContext`, invalidates caches, and reloads dashboard.

### AC-2: Add school via invite
**Given** I have an invite link/code **When** I tap Add and enter the code **Then** the school is added and pre-selected.

### AC-3: Cross-cutting
School name in entity.lang. Switching does NOT leak previous tenant's data into next render. Caches purged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `auth`)
- [ ] RTL-tested
- [ ] schoolId predicate (must enforce when switching)
- [ ] Role-gated (all)
- [ ] Audit logged (switch)

## Files
- `hogwarts/features/profile/views/schools-list-view.swift`
- `hogwarts/features/profile/viewmodels/schools-list-viewmodel.swift`
- `hogwarts/core/auth/tenant-context.swift` — switch helper

## API Contract
- `GET /api/mobile/profile/schools` → `[{ id, name, role, default }]`
- `POST /api/mobile/profile/schools/:id/select`
- `POST /api/mobile/profile/schools/join` — body `{ inviteCode }`

## i18n Keys
- `profile.schools.title`, `profile.schools.active`, `profile.schools.switch`, `profile.schools.add`, `profile.schools.invite_code`

## Tests
- `HogwartsTests/profile/schools-list-tests.swift`
- Multi-tenant isolation test (switch + verify data fence)

## Dependencies
- Depends on: AUTH-004, CORE-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
