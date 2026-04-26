# GRADE-002: Grade Detail with Rubric and Comments

**Epic**: GRADES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to tap a grade and see the rubric breakdown and teacher comments
**So that** I understand exactly why the score was given

## Acceptance Criteria

### AC-1: Rubric breakdown
**Given** a grade has a rubric **When** the user opens the detail **Then** each criterion, max points, and earned points are listed.

### AC-2: Comment in author's lang
**Given** the teacher's comment is in Arabic **When** rendered **Then** it displays with the entity's language font + direction even if app is in English.

### AC-3: No rubric fallback
**Given** a grade has no rubric **When** opened **Then** only the score, max, and comment block appear (no empty rubric section).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Comment respects `entity.lang`

## Files
- `hogwarts/features/grades/views/grade-detail-view.swift`
- `hogwarts/features/grades/viewmodels/grade-detail-viewmodel.swift`
- `hogwarts/features/grades/models/rubric.swift`

## API Contract
- `GET /api/mobile/grades/:id` — `{ rubric: [...], comment, comment_lang }`

## i18n Keys
- `marking.detail.rubric`, `marking.detail.comment`, `marking.detail.score`

## Tests
- `HogwartsTests/grades/grade-detail-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: GRADE-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
