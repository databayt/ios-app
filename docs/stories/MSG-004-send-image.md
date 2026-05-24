# MSG-004: Send Image

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to send images from my photo library or camera
**So that** I can share pictures inline in a chat

## Acceptance Criteria

### AC-1: Picker
**Given** the user taps the Image attachment button **When** the picker appears **Then** they choose Photos library or Camera and select up to N images.

### AC-2: Compression + upload
**Given** images are selected **When** sent **Then** they compress to a target size, upload via background URLSession, and appear as bubble previews with progress.

### AC-3: HEIC handling
**Given** an image is HEIC **When** uploaded **Then** it converts to JPEG server-side or pre-conversion ensures it displays on all platforms.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `common`)
- [ ] RTL-tested (bubble preview alignment)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/views/composer.swift` — image attach
- `hogwarts/features/messaging/services/image-upload-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/image` (multipart)

## i18n Keys
- `messaging.attach.image`, `messaging.image.uploading`, `messaging.image.failed`

## Tests
- `HogwartsTests/messaging/send-image-tests.swift`

## Dependencies
- Depends on: MSG-003, INT-005
- Blocks: MSG-022

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
