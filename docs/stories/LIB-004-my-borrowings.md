# LIB-004: My borrowings

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a list of my active and past borrowings
**So that** I track due dates

## Acceptance Criteria

### AC-1: Active
**Given** I have active loans **When** I open My Borrowings **Then** rows show book title (lang), borrowed_at, due_at, days remaining.

### AC-2: Past
**Given** Past tab **When** loaded **Then** completed loans shown with returned_at.

### AC-3: Cross-cutting
**Given** dates **When** rendered **Then** locale-formatted; titles in `book.lang`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang

## Files
- `hogwarts/features/library/views/my-borrowings-view.swift`
- `hogwarts/features/library/viewmodels/my-borrowings-viewmodel.swift`
- `hogwarts/features/library/models/borrowing-model.swift` — `@Model` with `schoolId`

## API Contract
- `GET /api/mobile/library/borrowings?status=active|past` — `[ { id, book:{title,lang}, borrowed_at, due_at, returned_at? } ]`

## i18n Keys
- `library.borrowings.title`
- `library.borrowings.active`
- `library.borrowings.past`
- `library.borrowings.due_in_days`

## Tests
- `HogwartsTests/library/my-borrowings-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: LIB-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
