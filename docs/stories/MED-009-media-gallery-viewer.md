# MED-009: Media Gallery Viewer

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user reviewing a chat thread or assignment with multiple attachments
**I want** a swipeable full-screen gallery
**So that** I can browse images, videos, and PDFs without leaving the conversation

## Acceptance Criteria

### AC-1: Swipe between assets
**Given** a list of `[MediaAsset]` **When** `HWMediaGallery.present(_:startIndex:)` opens **Then** users swipe horizontally to move between assets; pinch-to-zoom on images.

### AC-2: Mixed types
**Given** a gallery containing image + video + PDF **When** scrolled **Then** each renders with the appropriate viewer (Image/Video/PDF) and unified chrome.

### AC-3: Tenant-scoped URLs
**Given** signed URLs **When** fetched **Then** images use the tenant-keyed Nuke cache (MED-007); other media use direct URLs.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (signed URL + cache prefix)
- [ ] RTL-tested (swipe direction; in RTL forward is leading)
- [ ] Entity content rendered with `entity.lang` (caption text)

## Files
- `hogwarts/core/media/media-gallery.swift`
- `hogwarts/core/media/media-asset.swift` — typed asset enum
- `hogwarts/atoms/hw-media-gallery-chrome.swift`

## API Contract
- Consumes feature payloads listing `attachments: [{ url, type, mime_type, lang? }]`.

## i18n Keys
- `common.gallery.n_of_m`, `common.gallery.share`, `common.gallery.download`

## Tests
- `HogwartsTests/core/media/media-gallery-tests.swift` — swipe order, type dispatch, RTL direction

## Dependencies
- Depends on: MED-005, MED-006, MED-007, LOC-009
- Blocks: messaging attachments, assignment review

## Definition of Done
- [ ] AC met, RTL swipe verified, mixed-type fixture renders, AR + EN snapshots
