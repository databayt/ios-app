# MED-008: Resumable Upload Manager

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user uploading a 10MB+ photo or PDF
**I want** uploads to survive backgrounding and network changes
**So that** I never lose a half-finished upload

## Acceptance Criteria

### AC-1: Background upload session
**Given** a feature calls `UploadManager.upload(file:, target:)` **When** observed **Then** a `URLSession` background-configuration task starts; the app may suspend without losing the upload.

### AC-2: Chunked + resumable
**Given** a network drop mid-upload **When** reconnected **Then** the upload resumes from the last accepted byte using server's chunked protocol.

### AC-3: Progress emitted
**Given** an upload **When** progress changes **Then** `UploadManager.publishers[fileId]` emits `Progress(0...1)` consumable by the UI.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] schoolId predicate (upload tagged with current tenant)
- [ ] Audit logged (upload completion / failure)

## Files
- `hogwarts/core/media/upload-manager.swift` — actor + URLSession background delegate
- `hogwarts/HogwartsApp.swift` — `application(_:handleEventsForBackgroundURLSession:completionHandler:)`

## API Contract
- `POST /api/mobile/files` (verify resumable; if absent, file backend ticket per `backend-gaps.md` 🟡 Resumable upload endpoint)
  - Request: chunked upload with `Content-Range`
  - Response: `{ id, url, signed_at, size_bytes }`

## i18n Keys
- `common.upload.in_progress`, `common.upload.paused`, `errors.upload.failed`

## Tests
- `HogwartsTests/core/media/upload-manager-tests.swift` — chunk, resume, progress, background

## Dependencies
- Depends on: CORE-005, OFF-002, CORE-007 (feature flag while backend stabilizes)
- Blocks: MED-002 multi-page submission, assignment submission, fee receipt upload

## Definition of Done
- [ ] AC met, real-device suspend test (10MB photo), resume verified, parity preserved
