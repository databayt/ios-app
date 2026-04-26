# PERF-007: Background Processing (Off Main Thread Guarantees)

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** all I/O and decoding off the main thread
**So that** the UI never stalls

## Acceptance Criteria

### AC-1: No main-thread I/O
**Given** Main Thread Checker enabled
**When** the app runs
**Then** zero main-thread I/O warnings

### AC-2: Concurrency model
**Given** Swift Concurrency
**When** services run
**Then** explicit actors / `Task.detached` / `@MainActor` properly applied

### AC-3: Compile-time safety
**Given** strict concurrency
**When** project is built
**Then** zero data-race warnings

## Cross-Cutting Invariants
- [ ] Strict concurrency on
- [ ] schoolId-scoped queries off main

## Files
- `hogwarts/core/networking/api-client.swift`
- `hogwarts/core/storage/swiftdata-actor.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/perf/main-thread-tests.swift`

## Dependencies
- Depends on: PERF-002
- Blocks: —

## Definition of Done
- [ ] AC met, zero main-thread I/O, strict concurrency clean
