# SUB-005: Lesson detail

**Epic**: SUBJECTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
**As a** student or teacher
**I want** to view a lesson (text/video/quiz)
**So that** I consume content

## Acceptance Criteria

### AC-1: Renders by type
**Given** lesson **When** detail loads **Then** appropriate renderer (rich text body / video player / quiz launcher) shown with metadata.

### AC-2: Mark progress
**Given** I scroll/play to end **When** complete **Then** server records progress (consumed by STR-008 if Stream).

### AC-3: Cross-cutting
**Given** content in `lesson.lang` **When** rendering **Then** font + direction follow content lang; translate affordance if differs.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Translate affordance

## Files
- `hogwarts/features/subjects/views/lesson-detail-view.swift` — switches by type
- `hogwarts/features/subjects/viewmodels/lesson-detail-viewmodel.swift`

## API Contract
- `GET /api/mobile/lessons/:id` — `{ id, name, type, body|video_url|quiz_id, lang, duration_min }` (P2 backend)
- `POST /api/mobile/lessons/:id/progress` — `{ percent }`

## i18n Keys
- `common.lesson.duration`
- `common.lesson.complete`
- `common.lesson.translate`

## Tests
- `HogwartsTests/subjects/lesson-detail-tests.swift`

## Dependencies
- Depends on: SUB-004
- Blocks: STR-006, STR-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
