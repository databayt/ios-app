# STR-004: Chapter list with progress

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see chapters with my progress per lesson
**So that** I know what's done

## Acceptance Criteria

### AC-1: Chapters
**Given** course detail → chapters tab **When** loaded **Then** chapters with checkmarks per completed lesson.

### AC-2: Tap → lesson
**Given** lesson **When** tapped **Then** routes to STR-005/006/007 by type.

### AC-3: Cross-cutting
**Given** progress data **When** loaded **Then** keyed `<schoolId>:<userId>:<courseId>`; tenant-isolated.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang for chapter/lesson titles

## Files
- `hogwarts/features/stream/views/stream-chapter-list-view.swift`
- `hogwarts/features/stream/viewmodels/stream-chapter-viewmodel.swift`

## API Contract
- `GET /api/mobile/stream/courses/:id/chapters` — `[ { id, name, lang, lessons:[ { id, completed:bool } ] } ]`

## i18n Keys
- `common.stream.chapter.completed`
- `common.stream.chapter.locked`

## Tests
- `HogwartsTests/stream/chapter-progress-tests.swift`

## Dependencies
- Depends on: STR-003
- Blocks: STR-005, STR-006, STR-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
