# OBS-002: Custom Event Taxonomy

**Epic**: OBS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** a documented event taxonomy (auth, screen views, actions)
**So that** product analytics are consistent and queryable

## Acceptance Criteria

### AC-1: Taxonomy doc
**Given** event taxonomy
**When** committed
**Then** every event is `<feature>.<action>` with required props (`tenant_id`, `role`, `app_locale`)

### AC-2: Lint enforces names
**Given** new event added
**When** lint runs
**Then** non-conforming names fail CI

### AC-3: Sample events fired
**Given** the M0 features
**When** events fire
**Then** Sentry receives them with required props

## Cross-Cutting Invariants
- [ ] No PII in props
- [ ] schoolId tagged

## Files
- `docs/observability/event-taxonomy.md`
- `hogwarts/core/observability/event-tracker.swift`
- `hogwarts/scripts/lint-event-names.sh`

## API Contract
- (none — SDK)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/observability/event-taxonomy-tests.swift`

## Dependencies
- Depends on: OBS-001
- Blocks: OBS-006

## Definition of Done
- [ ] AC met, taxonomy doc + lint active
