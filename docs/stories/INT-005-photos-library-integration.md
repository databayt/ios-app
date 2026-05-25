# INT-005: Photos Library Integration

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M0
**Status**: done
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want to pick avatars and attachments from my Photos library, so that I can personalize profile and attach images to messages/announcements.

## Acceptance Criteria
### AC-1: PHPicker
**Given** the avatar/attachment screen **When** user taps "Choose Photo" **Then** PHPickerViewController opens (no permission required, modern API).

### AC-2: Upload + crop
**Given** an avatar selection **When** user confirms **Then** image is cropped to square, compressed, uploaded scoped to tenant.

### AC-3: Multiple selection for messages
**Given** user composes a message **When** picking attachments **Then** up to 10 photos can be selected and sent.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (upload URL signed per tenant)
- [ ] Audit logged for avatar change

## Files
- `hogwarts/core/integration/photo-picker-service.swift` — PHPicker wrapper
- `hogwarts/features/profile/views/avatar-edit-view.swift` — avatar UI
- `hogwarts/features/messaging/views/message-composer-view.swift` — attach UI

## API Contract
- `POST /api/mobile/uploads/avatar` — `{ imageBase64 | multipart }`, returns `{ url }`

## i18n Keys
- `common.photos.choose`
- `common.photos.upload`
- `common.photos.crop`
- `common.photos.error`

## Tests
- `HogwartsTests/integration/photo-picker-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
