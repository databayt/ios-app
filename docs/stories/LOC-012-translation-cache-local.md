# LOC-012: Translation Cache — Local Persistence + Invalidation

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** translations cached locally and invalidated when the source entity is edited
**So that** reading translated content is instant and never stale

## Acceptance Criteria

### AC-1: SwiftData model
**Given** a translation result **When** received **Then** it is stored in `@Model TranslationCacheEntry { schoolId, entityType, entityId, sourceLang, targetLang, body, fetchedAt }`.

### AC-2: Tenant-scoped lookup
**Given** a lookup **When** the FetchDescriptor runs **Then** it includes `schoolId` predicate; cross-tenant entries are unreachable.

### AC-3: Invalidation on update
**Given** the source entity's `updatedAt` is newer than `fetchedAt` **When** lookup runs **Then** the cache miss triggers a fresh translate call.

## Cross-Cutting Invariants
- [ ] schoolId predicate on every fetch
- [ ] Tenant-scoped cache invalidation on school switch (delegated to OFF-006)

## Files
- `hogwarts/core/translate/translation-cache-entry.swift` — `@Model`
- `hogwarts/core/translate/translation-cache.swift` — service used by LOC-010

## API Contract
- None (local persistence; consumes LOC-010's network result).

## i18n Keys
- None.

## Tests
- `HogwartsTests/locale/translation-cache-tests.swift` — store, lookup, invalidation, tenant scope

## Dependencies
- Depends on: LOC-010, OFF-001, OFF-006
- Blocks: none

## Definition of Done
- [ ] AC met, schoolId predicate verified, invalidation correctness checked, parity preserved
