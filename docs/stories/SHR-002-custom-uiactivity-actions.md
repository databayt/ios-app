# SHR-002: Custom UIActivity Actions

**Epic**: F-SHARING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want share-sheet actions like "Save Receipt" and "Save Report Card", so that I can persist key documents to Files in one tap.

## Acceptance Criteria
### AC-1: Custom UIActivity registration
**Given** a fee receipt or report card detail **When** user opens share sheet **Then** "Save to Files" custom activity appears alongside system options.

### AC-2: Save action
**Given** user taps "Save Receipt" **When** triggered **Then** a PDF is generated and written to Files (Hogwarts/<schoolName>/) with localized filename.

### AC-3: Tenant folder isolation
**Given** user belongs to multiple schools **When** saving **Then** files land in `Hogwarts/<schoolName>/` so each tenant has its own folder.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (filename in AR)
- [ ] schoolId scope (folder path)
- [ ] Role-gated (only user's own receipts/cards)
- [ ] Audit logged

## Files
- `hogwarts/core/sharing/custom-activities.swift` — UIActivity subclasses
- `hogwarts/features/fees/views/receipt-detail-view.swift` — wire activity
- `hogwarts/features/reportcard/views/report-card-detail-view.swift` — wire activity

## API Contract
None — PDF generated client-side from entity data.

## i18n Keys
- `common.share.saveReceipt`
- `common.share.saveReportCard`
- `common.share.saved`
- `common.share.saveError`

## Tests
- `HogwartsTests/sharing/custom-activities-tests.swift`
- Multi-tenant folder isolation test

## Dependencies
- Depends on: SHR-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
