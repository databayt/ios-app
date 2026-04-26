# OFF-001: SwiftData Schema Versioning + v1→v2 Migration Scaffold

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer evolving SwiftData models
**I want** versioned schema + a v1→v2 migration plan scaffold
**So that** model changes ship safely without wiping user data

## Acceptance Criteria

### AC-1: Versioned schemas
**Given** the data layer **When** declared **Then** `SchemaV1` and `SchemaV2` exist as distinct enums conforming to `VersionedSchema`.

### AC-2: Migration plan
**Given** a `MigrationPlan` **When** the container boots on a v1 store **Then** the lightweight migration to v2 succeeds; for non-trivial cases a custom stage is wired.

### AC-3: schoolId on every model
**Given** any `@Model` **When** declared in v2 **Then** it carries `schoolId: String` (audit script clean).

## Cross-Cutting Invariants
- [ ] schoolId field on every model

## Files
- `hogwarts/core/data/schema-v1.swift` — current
- `hogwarts/core/data/schema-v2.swift` — target with new fields
- `hogwarts/core/data/migration-plan.swift`

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/core/data/migration-plan-tests.swift` — boot v1 fixture store, assert v2 readable

## Dependencies
- Depends on: CORE-005
- Blocks: OFF-002, every feature using SwiftData

## Definition of Done
- [ ] AC met, fixture-store migration test green, audit script for schoolId clean
