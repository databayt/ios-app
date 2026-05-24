# MED-005: Video Player (AVKit) with Subtitle Support

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user watching a lesson or recorded class
**I want** a native video player with subtitle toggle and PiP
**So that** I can follow along comfortably

## Acceptance Criteria

### AC-1: Player wraps AVPlayer
**Given** a feature passes a signed video URL **When** `HWVideoPlayer(url:, subtitles:)` is presented **Then** AVKit's `AVPlayerViewController` opens with subtitles available.

### AC-2: RTL controls
**Given** Arabic locale **When** controls render **Then** play/forward/back buttons mirror correctly; chevrons flip.

### AC-3: PiP enabled
**Given** the user backgrounds **When** PiP is supported **Then** picture-in-picture activates.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (signed URL is tenant-scoped)
- [ ] RTL-tested (controls mirror)

## Files
- `hogwarts/core/media/video-player.swift`

## API Contract
- Consumes signed `video_url` from feature endpoints.

## i18n Keys
- `common.video.subtitles_on`, `common.video.subtitles_off`

## Tests
- `HogwartsTests/core/media/video-player-tests.swift` — subtitle toggle, RTL controls

## Dependencies
- Depends on: CORE-005
- Blocks: lessons, stream features

## Definition of Done
- [ ] AC met, RTL screenshots, PiP verified on real device
