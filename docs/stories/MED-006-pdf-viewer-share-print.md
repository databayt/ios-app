# MED-006: PDF Viewer + Share + Print

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** parent or student
**I want** to view PDF report cards / invoices and share or print them
**So that** I can review on-screen and keep paper copies

## Acceptance Criteria

### AC-1: PDFKit viewer
**Given** a feature presents a signed PDF URL **When** `HWPDFViewer(url:)` opens **Then** PDFKit renders with pagination, zoom, and bookmark navigation.

### AC-2: Share + Print
**Given** the viewer **When** the user taps Share **Then** UIActivityViewController offers AirPrint, AirDrop, Files, Mail.

### AC-3: Content language headers
**Given** the PDF carries an entity language indicator **When** rendered **Then** captions / headers above the PDF respect that language (LOC-009 helper).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (signed URL tenant-scoped)
- [ ] RTL-tested (header chrome)
- [ ] Entity content rendered with `entity.lang` (PDF chrome)

## Files
- `hogwarts/core/media/pdf-viewer.swift`

## API Contract
- Consumes signed `pdf_url` from feature endpoints.

## i18n Keys
- `common.pdf.share`, `common.pdf.print`, `common.pdf.page_n_of_m`

## Tests
- `HogwartsTests/core/media/pdf-viewer-tests.swift` — render, share sheet, language chrome

## Dependencies
- Depends on: LOC-009
- Blocks: invoices, report cards features

## Definition of Done
- [ ] AC met, AR + EN snapshots, share sheet verified
