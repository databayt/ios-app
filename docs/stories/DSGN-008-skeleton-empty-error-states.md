# DSGN-008: Skeleton + Empty + Error State Library

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** developer
**I want** standard skeleton, empty, and error state components
**So that** every list/detail screen presents consistent feedback during loading and edge cases

## Acceptance Criteria

### AC-1: Three primitives
**Given** any data-loading screen **When** it imports `HWSkeleton`, `HWEmptyState`, `HWErrorState` **Then** each accepts a localized title/description + optional CTA and renders consistently.

### AC-2: Composable
**Given** a list view **When** it wraps content in `HWAsyncContent { ... }` **Then** loading shows skeleton, success shows content, empty shows empty state, error shows error state with retry.

### AC-3: Reduce-Motion friendly
**Given** Reduce Motion is on **When** skeleton renders **Then** the shimmer animation is replaced with a static placeholder.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] Reduce-Motion respected

## Files
- `hogwarts/atoms/states/hw-skeleton.swift`
- `hogwarts/atoms/states/hw-empty-state.swift`
- `hogwarts/atoms/states/hw-error-state.swift`
- `hogwarts/atoms/states/hw-async-content.swift` — composer

## API Contract
- None.

## i18n Keys
- `common.empty.no_results`, `common.empty.no_data`, `errors.generic.title`, `errors.generic.retry`

## Tests
- `HogwartsTests/atoms/states/state-library-tests.swift` — snapshot per state × locale × motion flag

## Dependencies
- Depends on: DSGN-001, DSGN-005
- Blocks: every list/detail feature

## Definition of Done
- [ ] AC met, snapshot matrix green, reduce-motion variant verified
