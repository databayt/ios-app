# HOME-007: Multi-Role User Switcher

**Epic**: HOME
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user with two roles in one school (e.g., Teacher + Parent), I want to toggle between role contexts, so that I see the right tiles and dashboard.

## Acceptance Criteria
### AC-1: Toggle exposed when applicable
**Given** I have 2+ roles in current school **When** I open Home **Then** a role chip is visible in the header showing current role and a switcher.

### AC-2: Switching reloads home
**Given** I tap "Parent" while on Teacher **When** I confirm **Then** Home, dock, and dashboard re-render with parent context within 1s.

### AC-3: Cross-cutting
Switching does NOT cross-tenant leak (still same schoolId). Single-role users see no chip. RTL header preserves chevron direction.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate (preserved across switch)
- [ ] Role-gated (only when 2+ roles exist)
- [ ] Audit logged (role switch)

## Files
- `hogwarts/features/home/views/role-switcher-chip.swift`
- `hogwarts/core/auth/tenant-context.swift` — currentRole setter
- `hogwarts/features/home/viewmodels/role-switcher-viewmodel.swift`

## API Contract
- `GET /api/mobile/profile/roles` → `[{ role, schoolId, default }]`
- `POST /api/mobile/profile/role/select`

## i18n Keys
- `home.role.switcher.title`, `profile.role.<role>`, `home.role.switching`

## Tests
- `HogwartsTests/home/role-switcher-tests.swift`
- Multi-role isolation test

## Dependencies
- Depends on: PROF-009, HOME-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role isolation verified, parity preserved
