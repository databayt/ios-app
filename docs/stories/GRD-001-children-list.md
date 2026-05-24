# GRD-001: Children list

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** a list of my linked children (potentially across schools)
**So that** I see everyone in one place

## Acceptance Criteria

### AC-1: List
**Given** I have linked children **When** I open Children **Then** rows show photo, name (in child.lang), grade, school name.

### AC-2: Multi-school
**Given** kids in 2+ schools **When** rendering **Then** each row shows the school badge.

### AC-3: Cross-cutting
**Given** server filters by `guardian_id` **When** results **Then** scoped to my guardianship; no other guardians' children leak.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId per child row
- [ ] Entity content lang for child names
- [ ] Role gate (guardian only)

## Files
- `hogwarts/features/guardian/views/children-list-view.swift`
- `hogwarts/features/guardian/viewmodels/children-list-viewmodel.swift`
- `hogwarts/features/guardian/models/child-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/guardian/children` — `[ { id, name, lang, grade, school:{id, name, logo_url} } ]`

## i18n Keys
- `profile.children.title`
- `profile.children.grade`
- `profile.children.empty`

## Tests
- `HogwartsTests/guardian/children-list-tests.swift`
- Multi-school test, role-gate test

## Dependencies
- Depends on: AUTH-006
- Blocks: GRD-002, GRD-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, multi-school verified
