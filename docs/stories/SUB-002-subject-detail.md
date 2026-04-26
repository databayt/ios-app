# SUB-002: Subject detail (chapters, lessons)

**Epic**: SUBJECTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
**As a** student or teacher
**I want** subject detail with chapters and lesson counts
**So that** I see structure and progress

## Acceptance Criteria

### AC-1: Detail
**Given** subject **When** detail loads **Then** description, chapters list (each with lesson count), grade, instructor.

### AC-2: Drill chapters
**Given** chapter row **When** tapped **Then** routes to SUB-004.

### AC-3: Cross-cutting
**Given** description in `subject.lang` **When** rendering **Then** font + direction follow content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/subjects/views/subject-detail-view.swift`
- `hogwarts/features/subjects/viewmodels/subject-detail-viewmodel.swift`

## API Contract
- `GET /api/mobile/subjects/:id` — `{ id, name, body, lang, chapters:[ { id, name, lessons_count } ] }`

## i18n Keys
- `common.subject.chapters`
- `common.subject.instructor`
- `common.subject.grade`

## Tests
- `HogwartsTests/subjects/subject-detail-tests.swift`

## Dependencies
- Depends on: SUB-001
- Blocks: SUB-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
