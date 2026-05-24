# GRADE-003: GPA Summary Card (Cumulative + Term)

**Epic**: GRADES
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** a GPA summary card showing cumulative and current-term GPA
**So that** I can track overall academic standing at a glance

## Acceptance Criteria

### AC-1: Two-row card
**Given** the user opens Grades **When** the header renders **Then** a card shows "Cumulative GPA" and "Term GPA" with values formatted per locale (Arabic-Indic in `ar`).

### AC-2: Scale aware
**Given** the school uses a 4.0 scale **When** the card renders **Then** values display as `3.45 / 4.00`; for a 100-point school it shows `87 / 100`.

### AC-3: Empty state
**Given** no grades yet for the term **When** rendered **Then** card shows `--` placeholder, never `NaN` or `0.00`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/grades/views/gpa-summary-card.swift`
- `hogwarts/features/grades/viewmodels/gpa-viewmodel.swift`

## API Contract
- `GET /api/mobile/grades/summary/:id` — `{ cumulative_gpa, term_gpa, scale }`

## i18n Keys
- `results.gpa.cumulative`, `results.gpa.term`, `results.gpa.empty`

## Tests
- `HogwartsTests/grades/gpa-summary-tests.swift`
- Snapshots AR + EN, both scales

## Dependencies
- Depends on: CORE-001, GRADE-005
- Blocks: GRADE-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
