# PERF-005: Image Perf Audit (Lazy Load, Downsample)

**Epic**: Q-PERF
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user on slow networks
**I want** images to lazy-load and downsample
**So that** scrolling stays smooth

## Acceptance Criteria

### AC-1: Lazy load
**Given** lists with images
**When** scrolled
**Then** images request only when about to render (prefetch one screen ahead)

### AC-2: Downsample to display size
**Given** an image larger than display
**When** decoded
**Then** ImageIO downsample reduces memory before render

### AC-3: Cache hit rate
**Given** warm cache
**When** repeated views
**Then** ≥ 80% cache hit rate

## Cross-Cutting Invariants
- [ ] schoolId scoped image URLs (cdn.databayt.org)
- [ ] Cache trims on memory warning

## Files
- `hogwarts/core/image/image-loader.swift`
- `hogwarts/core/image/downsampler.swift`

## API Contract
- (none — CDN: cdn.databayt.org)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/perf/image-perf-tests.swift`

## Dependencies
- Depends on: PERF-002
- Blocks: —

## Definition of Done
- [ ] AC met, cache hit rate verified, downsample applied
