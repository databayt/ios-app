# STR-010: Download for offline

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to download chapters for offline viewing
**So that** I learn without connectivity

## Acceptance Criteria

### AC-1: Queue download
**Given** chapter **When** I tap "Download" **Then** all lessons (video + text + assets) downloaded with progress UI.

### AC-2: Manage storage
**Given** Settings → Downloads **When** opened **Then** total size shown; per-course delete option.

### AC-3: Cross-cutting
**Given** download stored **When** persisted **Then** keyed `<schoolId>:<courseId>:<lessonId>`; cleared on school switch.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId in cache key
- [ ] On-disk size reported in locale-formatted units

## Files
- `hogwarts/features/stream/services/download-manager-service.swift` — URLSession background
- `hogwarts/features/stream/views/downloads-manager-view.swift`
- `hogwarts/features/stream/viewmodels/downloads-viewmodel.swift`

## API Contract
- (uses lesson + asset URLs from STR-005/006)

## i18n Keys
- `common.stream.download.button`
- `common.stream.download.in_progress`
- `common.stream.download.delete`
- `common.stream.download.size_total`

## Tests
- `HogwartsTests/stream/download-manager-tests.swift`
- Tenant-key invalidation on school switch

## Dependencies
- Depends on: STR-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId cache key verified
