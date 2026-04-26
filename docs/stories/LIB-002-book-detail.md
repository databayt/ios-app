# LIB-002: Book detail

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** book detail with synopsis and availability
**So that** I can decide whether to borrow

## Acceptance Criteria

### AC-1: Detail
**Given** I tap a book **When** detail loads **Then** cover, title, author, synopsis, ISBN, copies available, hold queue length shown.

### AC-2: CTA
**Given** copies available **When** I tap "Hold" **Then** routed to LIB-005.

### AC-3: Cross-cutting
**Given** synopsis in `book.lang` **When** rendering **Then** font + direction respect content lang; translate affordance if differs.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Translate affordance

## Files
- `hogwarts/features/library/views/book-detail-view.swift`
- `hogwarts/features/library/viewmodels/book-detail-viewmodel.swift`

## API Contract
- `GET /api/mobile/library/books/:id` — `{ id, title, body, lang, author, isbn, copies, available, queue_length }` (P2)

## i18n Keys
- `library.book.synopsis`
- `library.book.copies_available`
- `library.book.queue`
- `library.book.hold`

## Tests
- `HogwartsTests/library/book-detail-tests.swift`

## Dependencies
- Depends on: LIB-001
- Blocks: LIB-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
