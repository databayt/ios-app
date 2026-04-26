# MED-003: File Picker — Files App Integration

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user attaching a PDF, doc, or zip
**I want** to pick from Files app (iCloud, Google Drive, etc.)
**So that** I can attach any document type

## Acceptance Criteria

### AC-1: Picker present
**Given** a feature calls `FilePicker.present(types: [.pdf, .image, .anything])` **When** invoked **Then** `UIDocumentPickerViewController` opens scoped to the requested types.

### AC-2: Result includes metadata
**Given** a selection **When** returned **Then** `PickerResult { url, mimeType, sizeBytes, originalFilename, schoolId }` is provided.

### AC-3: Size cap
**Given** file > 50MB **When** picked **Then** a localized "File too large" alert displays before upload.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] schoolId predicate
- [ ] RTL-tested (size-cap alert)

## Files
- `hogwarts/core/media/file-picker.swift`

## API Contract
- None.

## i18n Keys
- `common.media.file_picker.title`, `errors.media.file_too_large`

## Tests
- `HogwartsTests/core/media/file-picker-tests.swift` — type filter, size cap, result mapping

## Dependencies
- Depends on: CORE-005
- Blocks: DSGN-007 (FileField), assignment submission

## Definition of Done
- [ ] AC met, real-device verified, size-cap alert AR + EN
