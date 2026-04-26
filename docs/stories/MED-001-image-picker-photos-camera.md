# MED-001: Image Picker (Photos + Camera) with Permission Priming

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user attaching a photo (assignment, fee receipt, profile)
**I want** a unified picker that handles Photos and Camera with localized rationale
**So that** every feature attaches images consistently

## Acceptance Criteria

### AC-1: Picker entry
**Given** a feature calls `ImagePicker.present(source: .photos | .camera)` **When** invoked **Then** PHPicker (Photos) or AVFoundation Camera UI opens.

### AC-2: Permission rationale
**Given** Camera or Photos permission is undetermined **When** the picker is invoked **Then** a localized rationale screen appears before the system prompt.

### AC-3: Result handling
**Given** an image is selected **When** observed **Then** the picker returns `PickerResult { data, mimeType, originalFilename, schoolId }`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (result tagged with current tenant)
- [ ] RTL-tested (rationale screen)

## Files
- `hogwarts/core/media/image-picker.swift`
- `hogwarts/Info.plist` — `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`

## API Contract
- None (consumed by upload flows).

## i18n Keys
- `common.media.permission.photos.rationale`, `common.media.permission.camera.rationale`

## Tests
- `HogwartsTests/core/media/image-picker-tests.swift` — permission state, result mapping

## Dependencies
- Depends on: CORE-005
- Blocks: DSGN-007 (PhotoField), MED-008, MED-009

## Definition of Done
- [ ] AC met, AR + EN rationale snapshots, real-device picker verified
