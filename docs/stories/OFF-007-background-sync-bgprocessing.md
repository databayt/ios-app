# OFF-007: Background Sync via BGProcessingTask

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** the app to sync large datasets while plugged in overnight
**So that** opening the app in the morning is instant

## Acceptance Criteria

### AC-1: Task scheduled
**Given** the app backgrounds **When** scheduled **Then** `BGProcessingTask` with id `org.databayt.hogwarts.background-sync` is registered (requiresExternalPower = true).

### AC-2: Drains queue + pulls deltas
**Given** the task runs **When** executing **Then** it drains the PendingAction queue and pulls deltas for active features.

### AC-3: Tenant-scoped
**Given** the user has multiple schools **When** task runs **Then** sync occurs only for the most recent active `schoolId`.

## Cross-Cutting Invariants
- [ ] schoolId predicate (snapshot at task start)
- [ ] Audit logged (sync runs)

## Files
- `hogwarts/core/background/background-sync.swift` — registrar + handler
- `hogwarts/HogwartsApp.swift` — register task identifier

## API Contract
- Reuses existing delta endpoints.

## i18n Keys
- None (background, no UI).

## Tests
- `HogwartsTests/core/background/background-sync-tests.swift` — task handler, queue drain, delta fetch

## Dependencies
- Depends on: CORE-011, OFF-002, OFF-005, CORE-007 (feature flag)
- Blocks: none

## Definition of Done
- [ ] AC met, real-device debugger schedule observed, tenant scoped, parity preserved
