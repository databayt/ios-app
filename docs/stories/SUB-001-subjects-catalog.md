# SUB-001: Subjects catalog (school-adopted)

**Epic**: SUBJECTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
**As a** student or teacher
**I want** to browse the school's adopted subjects
**So that** I see what's offered

## Acceptance Criteria

### AC-1: List
**Given** subjects exist **When** I open Subjects **Then** rows show subject name, grade level, chapters count.

### AC-2: Filter
**Given** list visible **When** I filter by grade **Then** results scope.

### AC-3: Cross-cutting
**Given** subject titles in `subject.lang` **When** rendering **Then** font + direction follow content lang; tenant-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/subjects/views/subjects-catalog-view.swift`
- `hogwarts/features/subjects/viewmodels/subjects-catalog-viewmodel.swift`
- `hogwarts/features/subjects/models/subject-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/catalog/subjects?grade=...` — `[ { id, name, lang, grade, chapters_count } ]`

## i18n Keys
- `common.subjects.title`
- `common.subjects.filter.grade`
- `common.subjects.empty`

## Tests
- `HogwartsTests/subjects/catalog-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: SUB-002, SUB-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
