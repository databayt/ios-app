# PERF-002: Frame Rate Budget

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** 60fps everywhere and 120Hz on supported devices
**So that** scrolling and animations feel smooth

## Acceptance Criteria

### AC-1: No drops on top 20 lists
**Given** scrolling across the top 20 lists
**When** XCTOSSignpostMetric runs
**Then** no frame drop > threshold

### AC-2: 120Hz available
**Given** ProMotion device
**When** Info.plist `CADisableMinimumFrameDurationOnPhone` is set
**Then** 120Hz active under measurement

### AC-3: Profiled animations
**Given** key motion (transitions, hero)
**When** Instruments runs
**Then** GPU + CPU both within budget

## Cross-Cutting Invariants
- [ ] Reduce Motion respected
- [ ] RTL animations behave

## Files
- `hogwarts/Info.plist` — ProMotion setting
- `hogwarts/components/atom/**` — list perf
- `HogwartsTests/perf/scroll-perf-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Scroll perf tests

## Dependencies
- Depends on: TEST-011, A11Y-003
- Blocks: —

## Definition of Done
- [ ] AC met on iPhone 12 + ProMotion device
