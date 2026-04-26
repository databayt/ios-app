# GRADE-001: List Grades by Subject with Filter Chips

**Epic**: GRADES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to view grades grouped by subject with filter chips for assessment type
**So that** I can quickly see performance across exams, quizzes, assignments, midterms, and finals

## Acceptance Criteria

### AC-1: List renders by subject
**Given** the user opens Grades **When** the screen loads **Then** grades group by subject with totals and a filter chip row (All, Exam, Quiz, Assignment, Midterm, Final).

### AC-2: Chip filtering
**Given** the list is shown **When** the user taps "Quiz" **Then** only quiz grades remain and chip is selected; tapping again clears.

### AC-3: RTL + numerals
**Given** the app language is `ar` **When** the list renders **Then** layout flips to RTL and scores display in Arabic-Indic numerals.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate on every fetch
- [ ] Role-gated to student / guardian
- [ ] Comments rendered in entity content lang

## Files
- `hogwarts/features/grades/views/grades-list-view.swift` — chip filter UI
- `hogwarts/features/grades/viewmodels/grades-list-viewmodel.swift` — fetch + filter
- `hogwarts/features/grades/models/grade.swift` — `assessmentType` enum

## API Contract
- `GET /api/mobile/grades/student/:id` — returns grades scoped by `school_id`

## i18n Keys
- `marking.list.title`, `marking.filter.all`, `marking.filter.exam`, `marking.filter.quiz`, `marking.filter.assignment`

## Tests
- `HogwartsTests/grades/grades-list-tests.swift`
- Snapshots AR + EN, light + dark

## Dependencies
- Depends on: CORE-001, CORE-005
- Blocks: GRADE-002, GRADE-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
