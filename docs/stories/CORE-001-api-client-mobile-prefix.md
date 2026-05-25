# CORE-001: APIClient /api/mobile/* Prefix + snake_case Decoding

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer of any role-facing feature
**I want** a single APIClient that talks to `/api/mobile/*` and decodes snake_case
**So that** every feature integrates against the contract in `/api/mobile/README.md` without bespoke decoding

## Acceptance Criteria

### AC-1: Mobile prefix applied
**Given** any APIClient request **When** the path is provided **Then** it is rewritten to `/api/mobile/<path>` and old non-prefixed calls fail in debug builds.

### AC-2: snake_case decoding
**Given** a JSON response with `school_id`, `created_at` **When** decoded into Swift models **Then** `JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase` maps to `schoolId`, `createdAt` automatically.

### AC-3: Tenant header
**Given** a TenantContext with `currentSchoolId` **When** any request fires **Then** `X-School-Id` is appended as a secondary signal.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] schoolId verified on response payload
- [ ] Audit logged (via CORE-006 once available)

## Files
- `hogwarts/core/api/api-client.swift` — rewrite path builder + decoder strategy
- `hogwarts/core/api/api-error.swift` — surface decoding errors localized

## API Contract
- Affects every `/api/mobile/*` call. No new endpoint.

## i18n Keys
- `errors.network.decode_failed`, `errors.network.tenant_mismatch`

## Tests
- `HogwartsTests/core/api/api-client-prefix-tests.swift` — request rewriter + decoder

## Dependencies
- Depends on: none
- Blocks: CORE-002, CORE-005, all feature epics

## Definition of Done
- [ ] AC met, tests pass, no legacy `/api/` (non-mobile) calls remain, parity preserved
