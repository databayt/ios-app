# ID-001: ID card view (avatar, role, school, barcode/QR)

**Epic**: IDCARD
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to see my digital ID with QR/barcode
**So that** I can be identified at school

## Acceptance Criteria

### AC-1: Render
**Given** I open ID Card **When** loaded **Then** avatar, name (in user.lang), role, school name, QR/barcode of `<schoolId>:<userId>` shown.

### AC-2: Refresh
**Given** server data changes (role/photo) **When** I pull-to-refresh **Then** card re-fetches.

### AC-3: Cross-cutting
**Given** name in user.lang **When** rendering **Then** font + direction follow content lang; school theme colors applied.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId in QR payload
- [ ] Entity content lang for name
- [ ] School theme + logo from tenant config

## Files
- `hogwarts/features/idcard/views/idcard-view.swift`
- `hogwarts/features/idcard/viewmodels/idcard-viewmodel.swift`
- `hogwarts/features/idcard/models/idcard-model.swift` — `@Model` with `schoolId`

## API Contract
- `GET /api/mobile/idcard` — `{ id, name, lang, role, school:{name, logo_url, theme}, qr_payload }`

## i18n Keys
- `profile.idcard.title`
- `profile.idcard.role`
- `profile.idcard.school`

## Tests
- `HogwartsTests/idcard/idcard-view-tests.swift`
- Snapshot AR + EN, school theme test

## Dependencies
- Depends on: AUTH-006
- Blocks: ID-002, ID-003, ID-004, ID-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId in QR verified
