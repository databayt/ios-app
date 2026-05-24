# PROF-002: Profile Edit

**Epic**: PROFILE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to edit my name, phone, and bio, so that my profile reflects current information.

## Acceptance Criteria
### AC-1: Save persists across sessions
**Given** I edit name to "Ahmad" **When** I tap Save **Then** the field updates within 1s; after logout+login the change persists.

### AC-2: Validation errors inline
**Given** I clear name **When** I tap Save **Then** an inline error `profile.error.name_required` appears; submit is blocked.

### AC-3: Cross-cutting
Phone uses E.164 hint. Long bio (≤500 chars) wraps RTL correctly. Save mutation writes audit log.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (own profile only)
- [ ] Audit logged

## Files
- `hogwarts/features/profile/views/profile-edit-view.swift`
- `hogwarts/features/profile/viewmodels/profile-edit-viewmodel.swift`
- `hogwarts/features/profile/services/profile-service.swift`

## API Contract
- `PUT /api/mobile/profile` — body `{ name, phone, bio }` → returns updated profile

## i18n Keys
- `profile.edit.title`, `profile.field.name`, `profile.field.phone`, `profile.field.bio`, `profile.error.name_required`

## Tests
- `HogwartsTests/profile/profile-edit-tests.swift`
- Snapshot AR + EN + light/dark, multi-tenant isolation test

## Dependencies
- Depends on: PROF-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
