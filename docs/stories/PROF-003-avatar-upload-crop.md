# PROF-003: Avatar Upload with Crop

**Epic**: PROFILE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to upload and crop a profile photo, so that my avatar reflects my likeness.

## Acceptance Criteria
### AC-1: Pick → crop → upload
**Given** I tap the avatar **When** I pick a photo and crop to a square **Then** the image uploads in <5s on LTE and the new avatar appears immediately (optimistic).

### AC-2: Failure rolls back
**Given** upload fails **When** retry exceeds limit **Then** the avatar reverts to the previous one and a toast `profile.avatar.upload_failed` is shown.

### AC-3: Cross-cutting
Storage path is tenant-scoped (`/{schoolId}/avatars/{userId}.jpg`). EXIF stripped. Max 5 MB enforced client-side.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested (crop UI)
- [ ] schoolId predicate (storage path)
- [ ] Role-gated (own profile)
- [ ] Audit logged

## Files
- `hogwarts/features/profile/views/avatar-crop-view.swift`
- `hogwarts/features/profile/viewmodels/avatar-upload-viewmodel.swift`
- `hogwarts/features/profile/services/avatar-service.swift`

## API Contract
- `POST /api/mobile/profile/avatar` (multipart) → returns `{ avatarUrl }`

## i18n Keys
- `profile.avatar.pick`, `profile.avatar.crop_title`, `profile.avatar.upload_failed`, `profile.avatar.retry`, `common.save`

## Tests
- `HogwartsTests/profile/avatar-upload-tests.swift`
- Snapshot AR + EN + light/dark; multipart upload mocked

## Dependencies
- Depends on: PROF-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
