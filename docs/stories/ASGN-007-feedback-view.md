# ASGN-007: Feedback View (Teacher Comments)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to view teacher feedback inline with my submission
**So that** I understand what to improve next time

## Acceptance Criteria

### AC-1: Inline comments
**Given** a submission has teacher comments **When** the feedback view opens **Then** each comment renders alongside the relevant line/page/criterion, with the teacher's name and timestamp.

### AC-2: Author lang
**Given** comments are in Arabic **When** the app is in English **Then** comments render with Arabic font + RTL with Translate affordance per comment.

### AC-3: Empty
**Given** the submission was graded with no comments **When** opened **Then** only the score appears with "No additional feedback".

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Comments respect `entity.lang`

## Files
- `hogwarts/features/assignments/views/feedback-view.swift`
- `hogwarts/features/assignments/viewmodels/feedback-viewmodel.swift`

## API Contract
- `GET /api/mobile/assignments/:id/submissions/:sid/feedback` — `{ score, max, comments: [{ id, body, body_lang, anchor, by }] }`

## i18n Keys
- `results.asgn.feedback`, `results.asgn.no_feedback`, `results.asgn.commented_by`

## Tests
- `HogwartsTests/assignments/feedback-view-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: ASGN-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
