# ASGN-006: Submission History + Grade View

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to see my full submission history including grade per submission
**So that** I can track every attempt and the grade earned

## Acceptance Criteria

### AC-1: History list
**Given** an assignment allows resubmission **When** the user opens history **Then** a list shows each submission with timestamp, kind (file/photo/text), status, and grade (if graded).

### AC-2: Grade row
**Given** a submission is graded **When** the row renders **Then** it shows score / max with locale numerals and an arrow to feedback (ASGN-007).

### AC-3: Pending state
**Given** a submission is awaiting grading **When** rendered **Then** a "Pending review" badge appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/assignments/views/submission-history-view.swift`
- `hogwarts/features/assignments/viewmodels/submission-history-viewmodel.swift`

## API Contract
- `GET /api/mobile/assignments/:id/submissions/me` — `{ submissions: [{ id, kind, submitted_at, status, score?, max? }] }`

## i18n Keys
- `marking.asgn.history`, `marking.asgn.pending_review`, `marking.asgn.score`

## Tests
- `HogwartsTests/assignments/submission-history-tests.swift`

## Dependencies
- Depends on: ASGN-003, ASGN-004, ASGN-005
- Blocks: ASGN-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
