# CORE-009: Env Config (debug/staging/prod) via project.yml Schemes

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** API_BASE_URL, SENTRY_DSN, and feature defaults wired into Xcode schemes
**So that** every build target points at the right backend without code branches

## Acceptance Criteria

### AC-1: Three schemes exist
**Given** XcodeGen runs `project.yml` **When** schemes are listed **Then** Hogwarts-Debug, Hogwarts-Staging, Hogwarts-Production exist with distinct `API_BASE_URL` values.

### AC-2: Env reader
**Given** scheme env vars **When** `EnvConfig.shared.apiBaseURL` is read **Then** the correct URL is returned at runtime.

### AC-3: No prod URL in debug
**Given** Hogwarts-Debug runs **When** any request fires **Then** the destination must be the staging or local URL — never production.

## Cross-Cutting Invariants
- [ ] No secrets committed (DSN read from xcconfig, gitignored)

## Files
- `project.yml` — three schemes with distinct env vars
- `hogwarts/core/config/env-config.swift` — typed reader
- `Configurations/Debug.xcconfig` / `Staging.xcconfig` / `Production.xcconfig`

## API Contract
- None (config layer).

## i18n Keys
- None.

## Tests
- `HogwartsTests/core/config/env-config-tests.swift` — assert per-scheme values

## Dependencies
- Depends on: none
- Blocks: CORE-008, every backend integration

## Definition of Done
- [ ] AC met, three schemes build green, prod URL absent from debug logs
