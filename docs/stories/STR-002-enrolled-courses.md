# STR-002: Enrolled courses

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see my enrolled courses
**So that** I resume study

## Acceptance Criteria

### AC-1: List
**Given** enrollments **When** I open My Courses **Then** rows show progress %, last lesson, time remaining.

### AC-2: Resume
**Given** row **When** tapped **Then** routes to last lesson (STR-005/006).

### AC-3: Cross-cutting
**Given** title in `course.lang` **When** rendering **Then** font + direction respected.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Role gate (student)

## Files
- `hogwarts/features/stream/views/enrolled-courses-view.swift`
- `hogwarts/features/stream/viewmodels/enrolled-viewmodel.swift`

## API Contract
- `GET /api/mobile/stream/enrollments` — `[ { id, course:{id,title,lang}, progress, last_lesson_id } ]` (P2 backend)

## i18n Keys
- `common.stream.enrolled.title`
- `common.stream.enrolled.progress`
- `common.stream.enrolled.resume`

## Tests
- `HogwartsTests/stream/enrolled-tests.swift`

## Dependencies
- Depends on: STR-001
- Blocks: STR-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
