# LIB-005: Hold/reserve

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to place a hold on a book
**So that** it's reserved for me when available

## Acceptance Criteria

### AC-1: Hold
**Given** book detail **When** I tap "Hold" **Then** server records hold; queue position returned + shown.

### AC-2: Cancel
**Given** active hold **When** I tap "Cancel hold" **Then** removed from queue.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** scoped to `school_id`; audit `{ action:"library.hold" }`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`)
- [ ] RTL-tested
- [ ] schoolId on POST
- [ ] Audit logged

## Files
- `hogwarts/features/library/services/library-actions.swift` — `placeHold`, `cancelHold`
- `hogwarts/features/library/views/book-detail-view.swift`

## API Contract
- `POST /api/mobile/library/holds` — `{ book_id } → { id, queue_position }` (P2 backend)
- `DELETE /api/mobile/library/holds/:id`

## i18n Keys
- `library.hold.success`
- `library.hold.position`
- `library.hold.cancel`

## Tests
- `HogwartsTests/library/hold-tests.swift`

## Dependencies
- Depends on: LIB-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
