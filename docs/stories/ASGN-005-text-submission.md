# ASGN-005: Text Submission (Rich Text Editor)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to write and format my answer directly in the app and submit
**So that** I can complete short-answer assignments without external tools

## Acceptance Criteria

### AC-1: Rich text editor
**Given** the user taps Write & Submit **When** the editor opens **Then** they can apply bold/italic/lists, paste images, and the editor honors per-text-run direction (Arabic + Latin).

### AC-2: Auto-save draft
**Given** the user is typing **When** 5 seconds elapse without input **Then** the draft persists locally; on app relaunch it restores.

### AC-3: Submit
**Given** the user taps Submit **When** the request fires **Then** the rich text serializes (as JSON or HTML) and posts; success view confirms.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested (mixed bidi text)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Submission text stores `lang` of author

## Files
- `hogwarts/features/assignments/views/text-submission-view.swift`
- `hogwarts/features/assignments/views/rich-editor.swift`
- `hogwarts/features/assignments/viewmodels/text-submission-viewmodel.swift`

## API Contract
- `POST /api/mobile/assignments/:id/submissions` — `{ kind: text, body, body_lang }` → `{ submission_id }`

## i18n Keys
- `marking.asgn.write_submit`, `marking.asgn.draft_saved`, `marking.asgn.submitted`

## Tests
- `HogwartsTests/assignments/text-submission-tests.swift`
- Mixed-bidi rendering snapshot

## Dependencies
- Depends on: ASGN-002
- Blocks: ASGN-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
