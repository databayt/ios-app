# OBS-005: In-App Review Prompts (SKStoreReviewController)

**Epic**: OBS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** product owner
**I want** contextual in-app review prompts
**So that** happy users surface their satisfaction

## Acceptance Criteria

### AC-1: Contextual triggers
**Given** the user just completed a positive milestone (e.g., paid fee, received good grade)
**When** eligibility is met
**Then** SKStoreReviewController is requested

### AC-2: Apple cap respected
**Given** Apple's max-3-prompts/year cap
**When** the app requests
**Then** the request is throttled accordingly

### AC-3: Settings opt-out
**Given** the user opts out
**When** triggers fire
**Then** prompt is suppressed

## Cross-Cutting Invariants
- [ ] Localized prompt context
- [ ] schoolId tagged trigger reasons

## Files
- `hogwarts/core/observability/review-prompts.swift`
- `hogwarts/features/settings/views/feedback-settings.swift`

## API Contract
- (none — SKStoreReviewController)

## i18n Keys
- `common.review.opt_out`

## Tests
- `HogwartsTests/observability/review-prompts-tests.swift`

## Dependencies
- Depends on: OBS-002
- Blocks: —

## Definition of Done
- [ ] AC met, Apple cap honored, opt-out works
