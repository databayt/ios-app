# STR-008: Course progress

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see overall course progress
**So that** I know how close to completion

## Acceptance Criteria

### AC-1: Progress
**Given** course **When** progress tab opened **Then** ring chart % + per-chapter breakdown shown.

### AC-2: Updates live
**Given** I complete a lesson **When** I return **Then** progress reflects.

### AC-3: Cross-cutting
**Given** progress data **When** fetched **Then** scoped `<schoolId>:<userId>:<courseId>`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/stream/views/course-progress-view.swift`
- `hogwarts/features/stream/viewmodels/course-progress-viewmodel.swift`

## API Contract
- `GET /api/mobile/stream/courses/:id/progress` — `{ percent, chapters:[ { id, percent } ] }` (P2 backend)

## i18n Keys
- `common.stream.progress.title`
- `common.stream.progress.completed_lessons`
- `common.stream.progress.remaining`

## Tests
- `HogwartsTests/stream/course-progress-tests.swift`

## Dependencies
- Depends on: STR-005, STR-006, STR-007
- Blocks: STR-009

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
