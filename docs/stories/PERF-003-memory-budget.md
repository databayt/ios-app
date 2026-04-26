# PERF-003: Memory Budget

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** the app to keep memory under 150MB avg / 300MB max
**So that** the OS does not jetsam-kill it

## Acceptance Criteria

### AC-1: Stable memory across 30-min session
**Given** a long-running session
**When** Allocations Instruments runs
**Then** avg ≤ 150MB and max ≤ 300MB

### AC-2: No leaks
**Given** Instruments Leaks
**When** the app is exercised
**Then** no leaks reported

### AC-3: Image cache cap
**Given** image cache
**When** memory pressure rises
**Then** cache trims under low-memory warning

## Cross-Cutting Invariants
- [ ] schoolId switch resets caches
- [ ] Multi-tenant data hydration tested

## Files
- `hogwarts/core/cache/image-cache.swift`
- `HogwartsTests/perf/memory-perf-tests.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Memory perf tests

## Dependencies
- Depends on: TEST-011
- Blocks: —

## Definition of Done
- [ ] AC met on iPhone 12, Leaks zero, baseline committed
