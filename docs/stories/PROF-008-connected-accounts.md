# PROF-008: Connected Accounts

**Epic**: PROFILE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to view and unlink my Google/Apple/Facebook providers, so that I control which identities sign me in.

## Acceptance Criteria
### AC-1: List providers
**Given** I open Connected Accounts **When** the view loads **Then** I see each provider with status (linked / not linked) and last-used date.

### AC-2: Unlink with safety
**Given** I tap unlink on my only provider **When** I have no email/password fallback **Then** the action is blocked with `profile.connected.last_method` warning.

### AC-3: Cross-cutting
Provider icons mirrored correctly in RTL (icon stays right semantic). Audit log for each unlink.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `auth`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (own user)
- [ ] Audit logged

## Files
- `hogwarts/features/profile/views/connected-accounts-view.swift`
- `hogwarts/features/profile/viewmodels/connected-accounts-viewmodel.swift`
- `hogwarts/features/profile/services/connected-accounts-service.swift`

## API Contract
- `GET /api/mobile/profile/providers` → `[{ provider, linked, lastUsedAt }]`
- `DELETE /api/mobile/profile/providers/:provider`

## i18n Keys
- `profile.connected.title`, `profile.connected.linked`, `profile.connected.unlink`, `profile.connected.last_method`

## Tests
- `HogwartsTests/profile/connected-accounts-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: AUTH-001, AUTH-002, AUTH-003, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
