# PROF-001: Profile View

**Epic**: PROFILE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user (any role), I want to view my profile header (avatar, name, role badge, school), so that I can confirm my identity and current tenant at a glance.

## Acceptance Criteria
### AC-1: Header renders all elements
**Given** I am authenticated **When** I open Profile **Then** I see avatar, name, role badge, and current school name within 500ms (cached).

### AC-2: Loading + error states
**Given** the network is offline **When** I open Profile **Then** I see cached profile data plus a stale banner; no spinner blocks UI.

### AC-3: Cross-cutting
RTL: avatar leads on the trailing side in `ar`. Role badge label uses `profile.role.<role>`. School label uses `entity.lang`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate on profile fetch
- [ ] Role-gated (all roles)
- [ ] Audit logged: no (read-only)

## Files
- `hogwarts/features/profile/views/profile-view.swift` — header layout
- `hogwarts/features/profile/viewmodels/profile-viewmodel.swift` — fetch + cache
- `hogwarts/features/profile/services/profile-service.swift` — API wrapper

## API Contract
- `GET /api/mobile/profile` — returns `{ id, name, role, schoolId, schoolName, avatarUrl, bio, phone }`

## i18n Keys
- `profile.header.title`, `profile.role.<role>`, `profile.school.label`, `profile.stale.banner`

## Tests
- `HogwartsTests/profile/profile-view-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: AUTH-006, CORE-005
- Blocks: PROF-002, PROF-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
