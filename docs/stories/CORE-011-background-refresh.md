# CORE-011: Background Refresh (BGAppRefreshTask)

**Epic**: F-CORE
**Priority**: P0
**Phase**: M1
**Status**: done
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** parent or student
**I want** the app to fetch new announcements/messages in the background
**So that** when I open the app, content is already loaded

## Acceptance Criteria

### AC-1: Task scheduled
**Given** the app enters background **When** scheduled **Then** `BGAppRefreshTask` with id `org.databayt.hogwarts.refresh` is registered.

### AC-2: Refresh runs
**Given** the system grants execution **When** the task fires **Then** the sync engine pulls deltas for current `schoolId` and updates SwiftData; runtime under 25s.

### AC-3: Foreground-only writes
**Given** background context **When** the task runs **Then** no user-facing UI work occurs; only data fetch + cache update.

## Cross-Cutting Invariants
- [ ] schoolId predicate (TenantContext snapshot at task time)
- [ ] No mutations queued during background (only fills cache)

## Files
- `hogwarts/core/background/background-refresh.swift` — task registrar + handler
- `hogwarts/HogwartsApp.swift` — register task identifier in app boot

## API Contract
- Reads delta endpoints already wired by feature epics (no new endpoint).

## i18n Keys
- None (background, no UI).

## Tests
- `HogwartsTests/core/background/background-refresh-tests.swift` — task handler with stubbed sync engine

## Dependencies
- Depends on: CORE-005, OFF-001
- Blocks: OFF-007

## Definition of Done
- [ ] AC met, real-device background refresh observable (debugger schedule), tenant scoped
