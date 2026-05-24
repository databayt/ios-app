# PERF-004: Battery Budget

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** the app to consume ≤ 3% battery per active hour
**So that** my device lasts the day

## Acceptance Criteria

### AC-1: 1-hour active session
**Given** an active session of typical use
**When** Energy Log records
**Then** ≤ 3% battery consumed

### AC-2: Background consumption
**Given** the app is backgrounded
**When** measurement continues
**Then** background CPU/network is near-zero

### AC-3: WebSocket lifecycle
**Given** TRP-002 live tracking
**When** screen backgrounds
**Then** socket closes and energy drops

## Cross-Cutting Invariants
- [ ] Battery-savvy WebSocket lifecycle
- [ ] Background Modes minimized

## Files
- `hogwarts/core/networking/socket-lifecycle.swift`
- `HogwartsTests/perf/energy-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Energy test (manual + automated MetricKit)

## Dependencies
- Depends on: TEST-011, OBS-003
- Blocks: —

## Definition of Done
- [ ] AC met, MetricKit reports clean, baseline committed
