# SRCH-004: Recent Searches and Suggestions

**Epic**: F-SEARCH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want my recent searches plus role-aware suggestions, so that frequent queries are one tap away.

## Acceptance Criteria
### AC-1: Recent searches list
**Given** the search field is empty/focused **When** rendered **Then** the last 10 queries (per tenant) appear as taps; tapping re-runs the query.

### AC-2: Suggestions
**Given** the search field is empty **When** rendered **Then** a suggestions section shows role-relevant items (e.g., student: "My class", "Today's homework").

### AC-3: Tenant-isolated history
**Given** user switches schools **When** opening search **Then** recent searches show only entries for current schoolId.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (recents stored per tenant)
- [ ] Role-gated suggestions
- [ ] Audit logged on Clear Recents

## Files
- `hogwarts/features/search/services/recent-searches-store.swift` — SwiftData @Model
- `hogwarts/features/search/views/search-empty-view.swift` — recents UI
- `hogwarts/features/search/viewmodels/search-view-model.swift` — record query

## API Contract
None — local SwiftData with `schoolId` predicate.

## i18n Keys
- `common.search.recent.title`
- `common.search.recent.clear`
- `common.search.suggestions.title`

## Tests
- `HogwartsTests/search/recent-searches-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: SRCH-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
