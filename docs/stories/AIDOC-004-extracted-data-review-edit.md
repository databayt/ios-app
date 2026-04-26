# AIDOC-004: Extracted Data Review + Edit

**Epic**: AI-DOC
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to review and edit AI-extracted document data before confirming
**So that** OCR mistakes do not become permanent records

## Acceptance Criteria

### AC-1: Render extracted fields
**Given** a job is `succeeded`
**When** user opens review screen
**Then** all fields are pre-filled, editable, with `entity.lang` for content

### AC-2: Confirm creates record
**Given** user edits and taps "Confirm"
**When** server accepts
**Then** record is created and the job moves to `confirmed`

### AC-3: Discard
**Given** user taps "Discard"
**When** they confirm
**Then** job moves to `discarded` and no record is created

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian
- [ ] Audit log on confirm/discard
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/features/ai-doc/views/review-extracted-view.swift`
- `hogwarts/features/ai-doc/viewmodels/review-viewmodel.swift`
- `hogwarts/features/ai-doc/services/ai-doc-service.swift`

## API Contract
- `POST /api/mobile/ai-doc/jobs/:id/confirm` — `{ fields }` → `{ record_id }`
- `POST /api/mobile/ai-doc/jobs/:id/discard`

## i18n Keys
- `common.aidoc.review_title`, `confirm`, `discard`, `field_required`

## Tests
- `HogwartsTests/ai-doc/review-edit-tests.swift`

## Dependencies
- Depends on: AIDOC-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged, entity.lang verified
