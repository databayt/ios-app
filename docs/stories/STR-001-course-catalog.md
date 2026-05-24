# STR-001: Course catalog

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to browse the LMS course catalog
**So that** I can discover courses to enroll in

## Acceptance Criteria

### AC-1: List
**Given** courses exist **When** I open Stream **Then** rows show cover, title, instructor, level, duration.

### AC-2: Filter/search
**Given** list **When** I filter by level or search **Then** results update.

### AC-3: Cross-cutting
**Given** title in `course.lang` **When** rendering **Then** font + direction respected; tenant-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/stream/views/course-catalog-view.swift`
- `hogwarts/features/stream/viewmodels/course-catalog-viewmodel.swift`
- `hogwarts/features/stream/models/course-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/stream/courses?level=...&q=...` — `[ { id, title, lang, instructor, level, duration_min, cover_url } ]` (P2 backend)

## i18n Keys
- `common.stream.title`
- `common.stream.filter.level`
- `common.stream.empty`

## Tests
- `HogwartsTests/stream/course-catalog-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: STR-002, STR-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
