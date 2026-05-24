# MED-002: Document Scanner via VNDocumentCameraViewController

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** guardian uploading a bank receipt or admission document
**I want** to scan multiple pages with auto-edge detection
**So that** my paperwork is captured cleanly without third-party scanner apps

## Acceptance Criteria

### AC-1: Scanner present
**Given** a feature calls `DocumentScanner.present()` **When** invoked **Then** `VNDocumentCameraViewController` opens with Arabic and English UI strings localized.

### AC-2: Multi-page result
**Given** the user scans N pages **When** done **Then** result is `[ScannedPage { image, pageIndex }]` ready for upload.

### AC-3: Permission
**Given** Camera permission **When** missing **Then** rationale + system prompt fires (shared with MED-001).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (result tagged with tenant)
- [ ] RTL-tested

## Files
- `hogwarts/core/media/document-scanner.swift`

## API Contract
- None.

## i18n Keys
- `common.media.scanner.title`, `common.media.scanner.save`

## Tests
- `HogwartsTests/core/media/document-scanner-tests.swift` — result mapping, permission flow

## Dependencies
- Depends on: MED-001
- Blocks: admission, fee receipt features

## Definition of Done
- [ ] AC met, real-device scan verified, multi-page result confirmed
