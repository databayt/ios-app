# STR-006: Text lesson

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to read a text lesson with images and code blocks
**So that** I learn at my own pace

## Acceptance Criteria

### AC-1: Renders
**Given** text lesson **When** loaded **Then** rich body renders (markdown/HTML); images cached on first paint.

### AC-2: Reading progress
**Given** I scroll to bottom **When** ≥90% read **Then** marked complete via POST progress.

### AC-3: Cross-cutting
**Given** body in `lesson.lang` **When** rendering **Then** font + direction respected; mixed-language code blocks use LTR within RTL flow.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested with LTR code blocks (bidi)
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/stream/views/text-lesson-view.swift`
- `hogwarts/features/stream/viewmodels/text-lesson-viewmodel.swift`

## API Contract
- (consumes `GET /api/mobile/lessons/:id` for text type)
- `POST /api/mobile/stream/lessons/:id/complete`

## i18n Keys
- `common.stream.text.complete`
- `common.stream.text.next`

## Tests
- `HogwartsTests/stream/text-lesson-tests.swift`
- Bidi rendering test

## Dependencies
- Depends on: STR-004, SUB-005
- Blocks: STR-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
