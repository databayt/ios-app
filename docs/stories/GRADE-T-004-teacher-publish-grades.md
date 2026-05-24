# GRADE-T-004: Teacher Publish Grades to Students

**Epic**: GRADES
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to publish a batch of graded assessments to students
**So that** they see their grades only after I have finished reviewing

## Acceptance Criteria

### AC-1: Draft → published
**Given** entered grades sit in `draft` state **When** the teacher taps Publish **Then** every grade in the batch flips to `published` and a push notification is dispatched to each student.

### AC-2: Confirmation
**Given** the teacher taps Publish **When** the action sheet appears **Then** it shows "Publish N grades?" and a Cancel option.

### AC-3: Republish blocked
**Given** grades are already published **When** the teacher tries Publish again **Then** the button is disabled and a tooltip explains why.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged with `grades.publish`

## Files
- `hogwarts/features/grades/views/teacher-publish-view.swift`
- `hogwarts/features/grades/viewmodels/publish-viewmodel.swift`

## API Contract
- `POST /api/mobile/teacher/classes/:id/grades/publish` — `{ assessment_id }` → `{ published_count }`

## i18n Keys
- `marking.publish.cta`, `marking.publish.confirm`, `marking.publish.success`

## Tests
- `HogwartsTests/grades/publish-grades-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: GRADE-T-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
