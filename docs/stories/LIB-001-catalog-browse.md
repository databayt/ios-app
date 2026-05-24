# LIB-001: Catalog browse

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to browse the school library catalog
**So that** I can discover books

## Acceptance Criteria

### AC-1: List
**Given** library has books **When** I open Library **Then** rows show cover, title (in book lang), author, availability.

### AC-2: Sections
**Given** catalog **When** loaded **Then** sections: New arrivals, Popular, By subject (grid filterable).

### AC-3: Cross-cutting
**Given** book.lang ≠ app lang **When** rendering **Then** title font + direction follow `book.lang`; tenant-scoped.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`, `lab`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang for titles

## Files
- `hogwarts/features/library/views/catalog-browse-view.swift`
- `hogwarts/features/library/viewmodels/catalog-viewmodel.swift`
- `hogwarts/features/library/models/book-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/library/books?section=...` — `[ { id, title, lang, author, cover_url, available } ]` (P2 backend)

## i18n Keys
- `library.catalog.title`
- `library.catalog.section.new`
- `library.catalog.section.popular`
- `library.catalog.empty`

## Tests
- `HogwartsTests/library/catalog-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: LIB-002, LIB-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
