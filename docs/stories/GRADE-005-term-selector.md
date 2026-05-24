# GRADE-005: Term Selector

**Epic**: GRADES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to switch between academic terms
**So that** I can review past-term grades alongside the current term

## Acceptance Criteria

### AC-1: Term picker
**Given** the user is on Grades **When** they tap the term selector **Then** a menu lists terms (current first, then descending by date).

### AC-2: Reload on change
**Given** a term is selected **When** a different term is chosen **Then** the list, GPA card, and charts refetch scoped to the chosen term.

### AC-3: Default to active term
**Given** the user opens Grades for the first time **When** no preference is stored **Then** the active term auto-selects.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Term name in `entity.lang`

## Files
- `hogwarts/features/grades/views/term-selector.swift`
- `hogwarts/features/grades/viewmodels/grades-list-viewmodel.swift` — selectedTerm

## API Contract
- `GET /api/mobile/terms?school_id=...` — `{ terms: [{ id, name, start, end, active }] }`

## i18n Keys
- `marking.term.selector`, `marking.term.active`

## Tests
- `HogwartsTests/grades/term-selector-tests.swift`

## Dependencies
- Depends on: CORE-001
- Blocks: GRADE-001, GRADE-003, GRADE-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
