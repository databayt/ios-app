# SUB-003: My subjects (enrolled)

**Epic**: SUBJECTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
**As a** student or teacher
**I want** a list of my enrolled/teaching subjects
**So that** I land on what I work with daily

## Acceptance Criteria

### AC-1: Enrolled (student)
**Given** student **When** opens "My Subjects" **Then** rows = subjects in current term enrollment.

### AC-2: Teaching (teacher)
**Given** teacher **When** opens **Then** rows = subjects they teach + assigned classes.

### AC-3: Cross-cutting
**Given** server filters by `user_id` + `school_id` **When** results returned **Then** no cross-tenant subject leaks.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Role gate (student/teacher)

## Files
- `hogwarts/features/subjects/views/my-subjects-view.swift`
- `hogwarts/features/subjects/viewmodels/my-subjects-viewmodel.swift`

## API Contract
- `GET /api/mobile/subjects/my-subjects` — `[ { id, name, lang, role:"enrolled"|"teaching", classes?[] } ]`

## i18n Keys
- `common.my_subjects.title`
- `common.my_subjects.enrolled`
- `common.my_subjects.teaching`
- `common.my_subjects.empty`

## Tests
- `HogwartsTests/subjects/my-subjects-tests.swift`
- Role-based view test

## Dependencies
- Depends on: SUB-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
