# ASGN-003: File Submission (Files App)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to submit an assignment by selecting a file from the iOS Files app
**So that** I can hand in PDFs or documents already on my device or iCloud

## Acceptance Criteria

### AC-1: Files picker
**Given** the user taps Submit File **When** the picker opens **Then** they can browse iCloud Drive, On My iPhone, Google Drive, etc., and select one or more files.

### AC-2: Background upload
**Given** the user selects a file **When** upload starts **Then** a background URLSession transfers it; the user can leave the screen and return without interruption.

### AC-3: Retry on failure
**Given** the upload fails partway **When** the user reopens the assignment **Then** an inline retry option appears with the partially-uploaded state preserved.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (key includes school)
- [ ] Role-gated to student
- [ ] Audit logged on submission complete

## Files
- `hogwarts/features/assignments/views/file-submission-view.swift`
- `hogwarts/features/assignments/services/file-upload-service.swift`
- `hogwarts/features/assignments/viewmodels/submission-viewmodel.swift`

## API Contract
- `POST /api/mobile/assignments/:id/submissions` (multipart) — file + metadata → `{ submission_id, status: pending }`

## i18n Keys
- `marking.asgn.submit_file`, `marking.asgn.uploading`, `marking.asgn.upload_failed`, `marking.asgn.retry`

## Tests
- `HogwartsTests/assignments/file-submission-tests.swift`
- Background URLSession test

## Dependencies
- Depends on: ASGN-002, INT-004
- Blocks: ASGN-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
