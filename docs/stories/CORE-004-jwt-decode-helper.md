# CORE-004: JWT Decode Helper (schoolId / role / exp)

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** a tiny JWT decoder that reads `schoolId`, `role`, `exp` client-side
**So that** TenantContext and refresh logic can be primed without an extra API round-trip

## Acceptance Criteria

### AC-1: Claims extracted
**Given** a valid JWT **When** `JWTHelper.decode(_:)` runs **Then** it returns `{ sub, schoolId, role, exp }` without verifying signature (server is source of truth).

### AC-2: Malformed token rejected
**Given** an invalid JWT **When** decoded **Then** the helper throws `JWTError.malformed` and never crashes.

### AC-3: Exp comparison
**Given** an expired exp **When** `JWTHelper.isExpired(_:)` is called **Then** it returns true; CORE-002 uses this to short-circuit refresh.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)

## Files
- `hogwarts/core/auth/jwt-helper.swift` — Base64URL decode + JSONDecoder pass

## API Contract
- None (client-side only).

## i18n Keys
- `errors.auth.token_malformed`

## Tests
- `HogwartsTests/core/auth/jwt-helper-tests.swift` — fixture tokens (valid, expired, malformed)

## Dependencies
- Depends on: none
- Blocks: CORE-002, CORE-005

## Definition of Done
- [ ] AC met, tests cover edge cases, no third-party JWT dep added
