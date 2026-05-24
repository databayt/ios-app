# CORE-005: TenantContext Observable

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer of any feature
**I want** a single observable TenantContext exposing `currentSchoolId/Role/SchoolName/currency/languageDefault`
**So that** ViewModels never receive `schoolId` via prop drilling and school switches propagate automatically

## Acceptance Criteria

### AC-1: Single source of truth
**Given** an authenticated user **When** the JWT is decoded **Then** TenantContext is hydrated and `@Observable` consumers re-render.

### AC-2: require() throws when unset
**Given** TenantContext has no schoolId **When** `try TenantContext.shared.require()` is called **Then** it throws `TenantError.notSet`.

### AC-3: Switch invalidates
**Given** user switches school **When** `set(schoolId:)` is called **Then** all subscribers re-evaluate and dependent caches receive an invalidation notification.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] schoolId predicate enforced via `require()`
- [ ] Audit logged (school switch event)

## Files
- `hogwarts/core/auth/tenant-context.swift` — `@MainActor @Observable` singleton
- `hogwarts/core/auth/tenant-error.swift` — `TenantError` enum

## API Contract
- Reads `GET /api/mobile/profile` to hydrate `currency` and `languageDefault` per school.

## i18n Keys
- `errors.tenant.not_set`, `errors.tenant.cross_tenant_violation`

## Tests
- `HogwartsTests/core/auth/tenant-context-tests.swift` — hydrate, require, switch, invalidation

## Dependencies
- Depends on: CORE-004
- Blocks: CORE-006, OFF-006, every feature epic

## Definition of Done
- [ ] AC met, tests pass, no view-arg-passed schoolId remains in viewmodels (audit script clean)
