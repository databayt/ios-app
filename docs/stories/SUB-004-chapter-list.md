# SUB-004: Chapter list

**Epic**: SUBJECTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
**As a** student or teacher
**I want** a list of lessons within a chapter
**So that** I drill into content

## Acceptance Criteria

### AC-1: List
**Given** chapter **When** opened **Then** rows show lesson order, title, type (text/video/quiz), duration.

### AC-2: Tap → lesson
**Given** lesson row **When** tapped **Then** routes to SUB-005.

### AC-3: Cross-cutting
**Given** lesson titles in entity content lang **When** rendering **Then** font + direction respected; school-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/subjects/views/chapter-list-view.swift`
- `hogwarts/features/subjects/viewmodels/chapter-viewmodel.swift`

## API Contract
- `GET /api/mobile/subjects/:subject_id/chapters/:chapter_id` — `{ id, name, lessons:[ { id, name, type, duration_min, lang } ] }`

## i18n Keys
- `common.chapter.lessons`
- `common.chapter.type.text`
- `common.chapter.type.video`
- `common.chapter.type.quiz`

## Tests
- `HogwartsTests/subjects/chapter-list-tests.swift`

## Dependencies
- Depends on: SUB-002
- Blocks: SUB-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot
