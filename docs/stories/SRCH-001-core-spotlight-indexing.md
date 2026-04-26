# SRCH-001: Core Spotlight Indexing

**Epic**: F-SEARCH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want students, classes, messages, announcements, and events to surface in iOS Spotlight, so that I find school content from anywhere.

## Acceptance Criteria
### AC-1: Index on cache write
**Given** a SwiftData entity is written/updated **When** the cache write completes **Then** a CSSearchableItem is added with `domainIdentifier = <schoolId>:<entityType>` and localized attributeSet.

### AC-2: Tenant cleanup on switch
**Given** user switches schools **When** TenantContext changes **Then** all CSSearchableItems with old schoolId domain are removed via deleteSearchableItems(withDomainIdentifiers:).

### AC-3: Permission-aware indexing
**Given** an entity user does not have read permission **When** sync runs **Then** that entity is NOT indexed (server filters before client cache).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (Arabic search)
- [ ] schoolId scope (domain identifier prefix)
- [ ] Role-gated (server enforces visibility)

## Files
- `hogwarts/core/search/spotlight-indexer.swift` — index/remove APIs
- `hogwarts/core/data/swiftdata-stack.swift` — write hooks
- `hogwarts/core/auth/tenant-context.swift` — clear-on-switch hook

## API Contract
None — indexing is local; server only feeds permitted entities.

## i18n Keys
- `common.search.indexing`

## Tests
- `HogwartsTests/search/spotlight-indexer-tests.swift`
- Multi-tenant index isolation test

## Dependencies
- Depends on: AUTH-006
- Blocks: SRCH-002, SRCH-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
