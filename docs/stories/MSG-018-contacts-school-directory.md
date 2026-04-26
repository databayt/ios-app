# MSG-018: Contacts (School Directory)

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to browse the school directory of people I can message
**So that** I can find teachers, classmates, or staff to start a conversation

## Acceptance Criteria

### AC-1: Sectioned directory
**Given** the directory loads **When** the view renders **Then** people are sectioned by role (Teachers, Students, Staff, Admins, Guardians) with role-aware visibility per the role matrix.

### AC-2: Search
**Given** the user types in the search bar **When** results stream **Then** matches highlight on name regardless of name lang (Arabic + English).

### AC-3: Tenant scope
**Given** I belong to multiple schools **When** I open the directory **Then** only people from my currently-active school appear.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate (directory limited to school)
- [ ] Role-gated visibility per role matrix
- [ ] Names render with `user.lang` font

## Files
- `hogwarts/features/messaging/views/directory-view.swift`
- `hogwarts/features/messaging/viewmodels/directory-viewmodel.swift`

## API Contract
- `GET /api/mobile/directory?role=...` — `{ users: [{ id, name, name_lang, role, avatar_url }] }`

## i18n Keys
- `messaging.directory.title`, `messaging.directory.section.teachers`, `messaging.directory.section.students`, `messaging.directory.section.staff`

## Tests
- `HogwartsTests/messaging/directory-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: CORE-001
- Blocks: MSG-019

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
