# OFF-005: Offline Read Coverage — Per-Feature Checklist + Tests

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user opening the app in airplane mode
**I want** every read-only screen to display cached data
**So that** the app remains useful without a connection

## Acceptance Criteria

### AC-1: Coverage checklist
**Given** every feature epic **When** documented **Then** `docs/audits/offline-read-coverage.md` lists each read screen with status (cached / not-cached / partial).

### AC-2: Tests
**Given** every "cached" screen **When** the test suite runs in airplane mode **Then** the screen renders with cached data and a "Cached" indicator.

### AC-3: Empty state localized
**Given** no cache exists yet (fresh install offline) **When** opened **Then** an offline empty state appears with a "Try when online" CTA.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] schoolId predicate (cache reads tenant-scoped)
- [ ] RTL-tested

## Files
- `docs/audits/offline-read-coverage.md`
- Per-screen fixes filed under owning feature epic

## API Contract
- None.

## i18n Keys
- `common.offline.cached_indicator`, `common.offline.try_when_online`

## Tests
- `HogwartsTests/core/sync/offline-read-tests.swift` — drive each cached screen with stub URLProtocol that errors

## Dependencies
- Depends on: OFF-001
- Blocks: M0 ship

## Definition of Done
- [ ] AC met, audit doc complete, every "cached" row has a passing test, follow-ups filed
