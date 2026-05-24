# GRADE-T-002: Teacher Bulk Grade Entry (CSV-Style)

**Epic**: GRADES
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** a CSV-style table to enter scores for an entire class on one assessment
**So that** I can grade efficiently after a bulk marking session

## Acceptance Criteria

### AC-1: Roster table
**Given** an assessment is selected **When** the bulk view loads **Then** a scrollable table shows every student with a numeric input cell.

### AC-2: Atomic submit
**Given** the teacher enters scores for 30 students **When** they tap Save All **Then** all entries are submitted in one transaction with a single audit batch.

### AC-3: Partial validation
**Given** any row has an invalid score **When** Save All is tapped **Then** only valid rows submit, invalid rows highlight with inline errors and stay in edit state.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested (table flips)
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged per row

## Files
- `hogwarts/features/grades/views/teacher-bulk-entry-view.swift`
- `hogwarts/features/grades/viewmodels/bulk-entry-viewmodel.swift`
- `hogwarts/features/grades/services/grade-entry-service.swift`

## API Contract
- `POST /api/mobile/teacher/classes/:id/grades/bulk` — `{ assessment_id, entries: [{ student_id, score }] }` → `{ saved, errors }`

## i18n Keys
- `marking.bulk.title`, `marking.bulk.save_all`, `marking.bulk.errors.count`

## Tests
- `HogwartsTests/grades/bulk-entry-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: GRADE-T-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
