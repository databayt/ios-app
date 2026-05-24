# LIB-003: Library search

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to search the library by title, author, ISBN
**So that** I find a specific book quickly

## Acceptance Criteria

### AC-1: Search
**Given** Library tab **When** I type in search **Then** debounced 300ms; results list updates.

### AC-2: Empty + recent
**Given** no query **When** field empty **Then** show recent searches.

### AC-3: Cross-cutting
**Given** search index keyed by `<schoolId>` **When** results returned **Then** only this school's books surface; titles render in book.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`)
- [ ] RTL-tested search bar
- [ ] schoolId on query
- [ ] Entity content lang for titles
- [ ] Search index key includes schoolId

## Files
- `hogwarts/features/library/views/library-search-view.swift`
- `hogwarts/features/library/viewmodels/library-search-viewmodel.swift`

## API Contract
- `GET /api/mobile/library/books?q=...` — paged results (P2)

## i18n Keys
- `library.search.placeholder`
- `library.search.recent`
- `library.search.empty`

## Tests
- `HogwartsTests/library/search-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: LIB-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
