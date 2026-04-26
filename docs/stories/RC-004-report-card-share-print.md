# RC-004: Report Card Share and Print

**Epic**: REPORTCARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to share the report card PDF or send it to AirPrint
**So that** I can give a copy to relatives or print it

## Acceptance Criteria

### AC-1: Share sheet
**Given** the PDF is downloaded **When** the user taps Share **Then** the iOS share sheet appears with the PDF as the activity item.

### AC-2: Print
**Given** the user taps Print **When** AirPrint sheet appears **Then** they can select printer + paper size and submit.

### AC-3: Localized share title
**Given** the app is in `ar` **When** the share sheet appears **Then** the suggested filename and subject are in Arabic.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (filename includes school slug)
- [ ] Role-gated
- [ ] Filename respects `report_card.lang`

## Files
- `hogwarts/features/reportcard/views/report-card-detail-view.swift` — share + print toolbar
- `hogwarts/features/reportcard/services/share-service.swift`

## API Contract
- Reuses RC-003 PDF endpoint

## i18n Keys
- `results.reportcard.share`, `results.reportcard.print`, `results.reportcard.share_subject`

## Tests
- `HogwartsTests/reportcard/share-print-tests.swift`

## Dependencies
- Depends on: RC-003, SHR-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
