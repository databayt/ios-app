# SRCH-002: Universal Search Bar

**Epic**: F-SEARCH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want an in-app universal search bar with Spotlight continuation, so that I can find any entity quickly regardless of where I am.

## Acceptance Criteria
### AC-1: SearchBar entry
**Given** the home screen **When** user pulls down or taps the search icon **Then** a `.searchable` field opens with debounced query.

### AC-2: Backend search
**Given** a query of 2+ chars **When** debounce fires **Then** `GET /api/mobile/search?q=&types=` is called and grouped results render with type sections.

### AC-3: NSUserActivity continuation
**Given** user opened the app from a Spotlight result **When** the activity arrives **Then** the search bar pre-fills the query and routes to the matched entity.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (RTL search bar + results)
- [ ] schoolId scope (server enforces tenant)
- [ ] Role-gated (server returns only permitted)

## Files
- `hogwarts/features/search/views/search-view.swift` — SwiftUI .searchable
- `hogwarts/features/search/viewmodels/search-view-model.swift` — debounce
- `hogwarts/features/search/services/search-service.swift` — API
- `hogwarts/app/hogwarts-app.swift` — onContinueUserActivity for CSSearchableItemActionType

## API Contract
- `GET /api/mobile/search?q=<term>&types=student,class,announcement` — returns `{ results: [{ type, id, title, subtitle, schoolId }] }`

## i18n Keys
- `common.search.placeholder`
- `common.search.noResults`
- `common.search.recent`

## Tests
- `HogwartsTests/search/search-view-model-tests.swift`
- Multi-tenant scope test

## Dependencies
- Depends on: SRCH-001
- Blocks: SRCH-003, SRCH-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
