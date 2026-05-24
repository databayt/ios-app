# MSG-022: Media Gallery (Per Conversation)

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to view all media (images, videos, files) shared in a conversation
**So that** I can quickly find a previously shared item

## Acceptance Criteria

### AC-1: Tabs
**Given** the user opens "Media" from conversation info **When** the gallery loads **Then** tabs show Images / Files / Links with grid layouts.

### AC-2: Pagination
**Given** the conversation has many items **When** the user scrolls **Then** older items page in seamlessly.

### AC-3: QuickLook
**Given** the user taps an item **When** preview opens **Then** QuickLook displays the file/image with native gestures.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested (grid mirrors)
- [ ] schoolId predicate (gallery scoped)
- [ ] Role-gated
- [ ] Cache key includes school

## Files
- `hogwarts/features/messaging/views/media-gallery-view.swift`
- `hogwarts/features/messaging/viewmodels/media-gallery-viewmodel.swift`

## API Contract
- `GET /api/mobile/conversations/:id/media?kind=image|file|link&cursor=...` — paginated

## i18n Keys
- `messaging.gallery.title`, `messaging.gallery.images`, `messaging.gallery.files`, `messaging.gallery.links`

## Tests
- `HogwartsTests/messaging/media-gallery-tests.swift`

## Dependencies
- Depends on: MSG-004, MSG-005
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
