# PERF-006: List Perf Audit (`.id`, Prefetch)

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** lists to scroll smoothly with stable identities
**So that** rows do not flicker or rebuild unnecessarily

## Acceptance Criteria

### AC-1: Stable identities
**Given** SwiftUI Lists / LazyVStack
**When** data changes
**Then** rows use stable `.id` and do NOT rebuild for unchanged items

### AC-2: Prefetch
**Given** scroll near end
**When** at threshold
**Then** next page is requested

### AC-3: No frame drops
**Given** 1000-row list
**When** scrolled
**Then** no frame drop > threshold (XCTOSSignpostMetric)

## Cross-Cutting Invariants
- [ ] schoolId scoped data
- [ ] RTL scroll inertia verified

## Files
- `hogwarts/components/atom/list-row.swift`
- `hogwarts/features/<feature>/views/*-list-view.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/perf/list-perf-tests.swift`

## Dependencies
- Depends on: PERF-002
- Blocks: —

## Definition of Done
- [ ] AC met, top 20 lists audited, no frame drops
