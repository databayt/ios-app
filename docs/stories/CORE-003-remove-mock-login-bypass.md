# CORE-003: Remove Mock Login Bypass

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** security-minded engineer
**I want** the mock login bypass deleted from auth-manager.swift
**So that** no shipping build can authenticate without real credentials

## Acceptance Criteria

### AC-1: Bypass removed
**Given** the codebase **When** I grep for `mockLogin`, `bypassLogin`, or `DEBUG_AUTH` **Then** zero hits remain.

### AC-2: Tests still green
**Given** removal of bypass **When** running `HogwartsTests` **Then** legitimate auth tests use a stubbed `URLProtocol` injected at the APIClient layer instead.

## Cross-Cutting Invariants
- [ ] Audit logged (failed auth attempts)

## Files
- `hogwarts/core/auth/auth-manager.swift` — delete bypass branch
- `HogwartsTests/core/auth/auth-test-helpers.swift` — replace bypass with URLProtocol stub

## API Contract
- None.

## i18n Keys
- None.

## Tests
- Existing `auth-manager-tests.swift` updated to use URLProtocol stubbing

## Dependencies
- Depends on: CORE-002
- Blocks: production cut

## Definition of Done
- [ ] AC met, grep clean, tests green, no debug bypass present in any scheme
