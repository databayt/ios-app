# MED-007: Image Cache (Nuke) with Tenant-Scoped Keys

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** all image cache keys prefixed by `<schoolId>:`
**So that** school A's avatars never leak to school B's session

## Acceptance Criteria

### AC-1: Tenant-prefixed keys
**Given** any image fetch via `HWImage(url:)` **When** Nuke caches **Then** the cache key is `<schoolId>:<resourceId>`; cross-tenant lookups miss by design.

### AC-2: School switch evicts
**Given** OFF-006 fires school switch **When** invalidation runs **Then** all keys with the old prefix are removed from disk + memory caches.

### AC-3: Configurable cap
**Given** the configured 200MB disk cap **When** exceeded **Then** Nuke evicts LRU within the current tenant first.

## Cross-Cutting Invariants
- [ ] schoolId predicate (cache key prefix)
- [ ] Tenant-scoped cache invalidation on school switch

## Files
- `hogwarts/core/cache/image-cache-tenant-key.swift` — Nuke `ImageCaching` adapter
- `hogwarts/atoms/hw-image.swift` — opinionated wrapper over `LazyImage`

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/core/cache/image-cache-tests.swift` — key prefix, eviction by prefix, cap behaviour

## Dependencies
- Depends on: CORE-005
- Blocks: OFF-006, PUSH-006, MED-009

## Definition of Done
- [ ] AC met, leak test green, cap behaviour verified, parity preserved
