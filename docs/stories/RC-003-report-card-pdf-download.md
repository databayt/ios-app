# RC-003: Report Card PDF Download

**Epic**: REPORTCARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to download the report card as a PDF
**So that** I can keep an offline copy or print it

## Acceptance Criteria

### AC-1: PDF preview
**Given** a published report card **When** the user taps Download PDF **Then** the PDF is fetched, cached locally, and previewed in PDFKit.

### AC-2: Offline cache
**Given** the user previously downloaded the PDF **When** offline **Then** the cached copy opens instantly.

### AC-3: Server lang fidelity
**Given** the report card is in Arabic **When** the PDF is rendered server-side **Then** the iOS preview displays Arabic text correctly with embedded fonts.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (cache key includes school)
- [ ] Role-gated
- [ ] PDF respects `report_card.lang`

## Files
- `hogwarts/features/reportcard/views/report-card-pdf-view.swift`
- `hogwarts/features/reportcard/services/pdf-cache-service.swift`

## API Contract
- `GET /api/mobile/report-cards/:id/pdf` — returns PDF binary with `Content-Type: application/pdf`

## i18n Keys
- `results.reportcard.download_pdf`, `results.reportcard.pdf_loading`, `common.error.network`

## Tests
- `HogwartsTests/reportcard/pdf-download-tests.swift`
- Offline cache test

## Dependencies
- Depends on: RC-002
- Blocks: RC-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
