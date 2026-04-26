# OFF-004: Sync Status Banner — Granular Per-Feature

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to see precisely which feature is syncing/queued/offline
**So that** I trust the app and know when my action will apply

## Acceptance Criteria

### AC-1: Per-feature state
**Given** a feature publishes its sync state via `SyncStatusBus.publish(.attendance, .syncing)` **When** the app top banner reads **Then** it shows the currently active feature and its state.

### AC-2: Aggregate
**Given** multiple features sync **When** observed **Then** the banner aggregates counts ("3 features syncing") and tap reveals the per-feature breakdown.

### AC-3: Connection state
**Given** the device is offline **When** the banner shows **Then** "Offline — N actions queued" displays with TenantContext-scoped count.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] schoolId predicate (queued counts tenant-scoped)
- [ ] RTL-tested

## Files
- `hogwarts/core/sync/sync-status-bus.swift` — pub/sub
- `hogwarts/atoms/hw-sync-banner.swift`

## API Contract
- None.

## i18n Keys
- `common.sync.online`, `common.sync.offline`, `common.sync.syncing_feature`, `common.sync.actions_queued_n`

## Tests
- `HogwartsTests/core/sync/sync-banner-tests.swift` — per-feature, aggregate, offline

## Dependencies
- Depends on: OFF-002
- Blocks: every feature epic UI

## Definition of Done
- [ ] AC met, snapshot AR + EN, breakdown sheet works, plurals tested
