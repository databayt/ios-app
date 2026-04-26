# ID-003: ID card PDF export

**Epic**: IDCARD
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to export my ID card as PDF
**So that** I can print or email it

## Acceptance Criteria

### AC-1: Export
**Given** ID-001 **When** I tap "Export PDF" **Then** PDF rendered with school theme + QR; saved/shared.

### AC-2: Cross-cutting
**Given** PDF renders **When** generated **Then** name in `user.lang`; school logo from tenant.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested PDF preview
- [ ] schoolId in QR + filename
- [ ] Entity content lang in name
- [ ] School theme

## Files
- `hogwarts/features/idcard/services/idcard-pdf-service.swift`
- `hogwarts/features/idcard/views/idcard-view.swift`

## API Contract
- `GET /api/mobile/idcard/pdf` — binary PDF (P2 backend)

## i18n Keys
- `profile.idcard.export_pdf`

## Tests
- `HogwartsTests/idcard/pdf-export-tests.swift`

## Dependencies
- Depends on: ID-001
- Blocks: ID-004

## Definition of Done
- [ ] AC met, tests pass, RTL PDF screenshot, schoolId in payload verified
