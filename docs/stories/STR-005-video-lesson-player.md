# STR-005: Video lesson player (offline-cacheable)

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a video lesson player with PiP and offline cache
**So that** I learn anywhere

## Acceptance Criteria

### AC-1: Playback
**Given** video lesson **When** loaded **Then** AVPlayer plays; PiP supported; subtitles in `lesson.lang` available.

### AC-2: Progress
**Given** play to ≥90% **When** complete **Then** lesson marked complete (POST progress); next lesson auto-suggested.

### AC-3: Offline cache
**Given** prior download (STR-010) **When** offline **Then** plays from cache keyed `<schoolId>:<courseId>:<lessonId>`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested controls
- [ ] schoolId in cache key
- [ ] Entity content lang for subtitles
- [ ] Reduced Motion respected for transitions

## Files
- `hogwarts/features/stream/views/video-lesson-player-view.swift`
- `hogwarts/features/stream/services/video-cache-service.swift`
- `hogwarts/features/stream/viewmodels/video-lesson-viewmodel.swift`

## API Contract
- `GET /api/mobile/lessons/:id` — video URL + subtitle URLs
- `POST /api/mobile/stream/lessons/:id/complete`

## i18n Keys
- `common.stream.player.next_lesson`
- `common.stream.player.subtitle.toggle`
- `common.stream.player.offline_indicator`

## Tests
- `HogwartsTests/stream/video-player-tests.swift`
- Offline playback test, multi-tenant cache key test

## Dependencies
- Depends on: STR-004, SUB-005
- Blocks: STR-008, STR-010

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId in cache verified
