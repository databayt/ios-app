# OFF-006: Tenant-Scoped Cache Invalidation on School Switch

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** multi-school user
**I want** all caches invalidated when I switch schools
**So that** school A data never appears under school B's session

## Acceptance Criteria

### AC-1: Image cache invalidation
**Given** I switch from school A to school B **When** the switch completes **Then** Nuke cache entries with prefix `<schoolA>:` are evicted.

### AC-2: SwiftData isolation preserved
**Given** the switch **When** any FetchDescriptor runs **Then** results return only school B rows (predicate-enforced; no manual purge required for SwiftData).

### AC-3: In-flight requests cancelled
**Given** the switch **When** in-flight URLSessionTasks exist **Then** they are cancelled before TenantContext flips.

## Cross-Cutting Invariants
- [ ] schoolId predicate (audit script clean post-switch)
- [ ] Audit logged (school switch event)
- [ ] No cross-tenant data leak (test enforces)

## Files
- `hogwarts/core/auth/tenant-switcher.swift` — orchestrates cancel + invalidate + flip
- `hogwarts/core/cache/image-cache-tenant-key.swift` — eviction by prefix

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/core/auth/tenant-switch-tests.swift` — invalidation correctness, no leak across switch

## Dependencies
- Depends on: CORE-005, OFF-001, MED-007
- Blocks: multi-school users

## Definition of Done
- [ ] AC met, leak test green, manual switch verified, parity preserved
