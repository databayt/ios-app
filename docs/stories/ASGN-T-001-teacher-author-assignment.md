# ASGN-T-001: Teacher Author Assignment (Form + Attachments)

**Epic**: ASSIGNMENTS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to author a new assignment with description, attachments, and rubric
**So that** I can post structured assignments to a class

## Acceptance Criteria

### AC-1: Author form
**Given** the teacher opens "New Assignment" **When** the form appears **Then** required fields are Title, Class, Due At, Description, plus optional Attachments and Rubric.

### AC-2: Attach files
**Given** the teacher taps Add Attachment **When** the picker appears **Then** they can pick from Files, take a photo, or scan; uploads happen via background URLSession.

### AC-3: Save + publish
**Given** the form is valid **When** the teacher taps Publish **Then** the assignment posts with `school_id`, students are notified, and an audit log entry records the action.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged

## Files
- `hogwarts/features/assignments/views/teacher-author-view.swift`
- `hogwarts/features/assignments/viewmodels/author-viewmodel.swift`
- `hogwarts/features/assignments/services/author-service.swift`

## API Contract
- `POST /api/mobile/teacher/classes/:id/assignments` — `{ title, due_at, description, description_lang, attachments: [...], rubric? }`

## i18n Keys
- `marking.asgn.author_title`, `marking.asgn.due_at`, `marking.asgn.publish`

## Tests
- `HogwartsTests/assignments/teacher-author-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: CORE-001, CORE-006, INT-004
- Blocks: ASGN-T-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
