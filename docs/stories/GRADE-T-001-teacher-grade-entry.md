# GRADE-T-001: Teacher Grade Entry per Assessment

**Epic**: GRADES
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to enter a grade for a single student on an assessment
**So that** I can record marks as I grade papers individually

## Acceptance Criteria

### AC-1: Single entry form
**Given** a teacher selects an assessment + student **When** they enter a score and tap Save **Then** the grade persists with `school_id` and an audit log entry is written.

### AC-2: Validation
**Given** a teacher enters a score above the max **When** Save is tapped **Then** an inline error blocks submission and the field highlights.

### AC-3: Offline queue
**Given** the device is offline **When** Save is tapped **Then** the entry queues locally and syncs on reconnect.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged on mutation

## Files
- `hogwarts/features/grades/views/teacher-grade-entry-view.swift`
- `hogwarts/features/grades/viewmodels/teacher-grade-entry-viewmodel.swift`
- `hogwarts/features/grades/services/grade-entry-service.swift`

## API Contract
- `POST /api/mobile/teacher/classes/:id/grades` — `{ student_id, assessment_id, score, comment? }` → `{ id, score, school_id }`

## i18n Keys
- `marking.entry.score`, `marking.entry.comment`, `marking.entry.error.range`, `marking.entry.saved`

## Tests
- `HogwartsTests/grades/teacher-grade-entry-tests.swift`
- Snapshots AR + EN
- Multi-tenant isolation test

## Dependencies
- Depends on: CORE-006 (audit), CORE-001
- Blocks: GRADE-T-002, GRADE-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
