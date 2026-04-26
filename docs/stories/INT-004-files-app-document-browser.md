# INT-004: Files App Integration (Document Browser)

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want to upload assignment files via the iOS Files app, so that I can pick from iCloud Drive, Google Drive, or any provider.

## Acceptance Criteria
### AC-1: Pick from Files
**Given** the assignment submission screen **When** user taps "Choose File" **Then** UIDocumentPickerViewController opens with allowed UTTypes (pdf, docx, images).

### AC-2: Upload progress
**Given** a file is selected **When** upload begins **Then** progress is shown with cancel; on success, file appears in submission list with size and tenant scope.

### AC-3: Validation
**Given** a file > 25 MB or unsupported type **When** picked **Then** an inline error displays without crashing.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (upload payload + URL signed per tenant)
- [ ] Role-gated (student submits, teacher attaches)
- [ ] Audit logged (file.uploaded)

## Files
- `hogwarts/core/integration/document-picker-service.swift` — wrapper
- `hogwarts/features/assignments/views/assignment-submit-view.swift` — UI
- `hogwarts/features/assignments/viewmodels/assignment-submit-view-model.swift` — upload

## API Contract
- `POST /api/mobile/assignments/{id}/upload` — multipart, returns `{ fileId, url, sizeBytes }`

## i18n Keys
- `common.files.choose`
- `common.files.uploading`
- `common.files.tooLarge`
- `common.files.unsupportedType`

## Tests
- `HogwartsTests/integration/document-picker-tests.swift`
- Multi-tenant upload isolation test

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
