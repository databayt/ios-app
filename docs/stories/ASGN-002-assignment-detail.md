# ASGN-002: Assignment Detail (Description, Attachments, Rubric)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to view full assignment details including description, attachments, and rubric
**So that** I understand exactly what to do and how I will be graded

## Acceptance Criteria

### AC-1: Sections
**Given** an assignment is opened **When** the view loads **Then** sections show Title, Class, Due, Description, Attachments, Rubric, and Submission area.

### AC-2: Author lang
**Given** the description is in Arabic **When** the app is in English **Then** description text uses Arabic font + RTL with Translate option.

### AC-3: Attachment preview
**Given** the user taps an attachment **When** preview opens **Then** PDF or image displays via QuickLook; cache key includes school.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Description respects `entity.lang`

## Files
- `hogwarts/features/assignments/views/assignment-detail-view.swift`
- `hogwarts/features/assignments/viewmodels/assignment-detail-viewmodel.swift`
- `hogwarts/features/assignments/services/attachment-cache.swift`

## API Contract
- `GET /api/mobile/assignments/:id` — `{ id, title, description, description_lang, attachments: [...], rubric, due_at }`

## i18n Keys
- `marking.asgn.description`, `marking.asgn.attachments`, `marking.asgn.rubric`

## Tests
- `HogwartsTests/assignments/detail-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: ASGN-001
- Blocks: ASGN-003, ASGN-004, ASGN-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
