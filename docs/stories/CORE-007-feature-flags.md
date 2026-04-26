# CORE-007: Feature Flags (@AppStorage-backed)

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** product owner
**I want** to toggle risky stories on/off without redeploying
**So that** we can ramp features gradually and disable them instantly if a regression appears

## Acceptance Criteria

### AC-1: Read flag
**Given** a feature wraps `@FeatureFlag(.translationOnDemand)` **When** read **Then** the value comes from `@AppStorage` with a default fallback.

### AC-2: Server-overridable
**Given** the profile endpoint returns `feature_flags: { ... }` **When** profile syncs **Then** server values override local AppStorage defaults.

### AC-3: Debug toggle UI
**Given** a debug build **When** Settings → Developer is opened **Then** every flag is listed with a toggle.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)

## Files
- `hogwarts/core/flags/feature-flag.swift` — registry + property wrapper
- `hogwarts/features/settings/views/developer-flags-view.swift` — debug toggle UI (debug only)

## API Contract
- Consumes `feature_flags` in `GET /api/mobile/profile` response.

## i18n Keys
- `common.developer.feature_flags`

## Tests
- `HogwartsTests/core/flags/feature-flag-tests.swift` — default, override, persistence

## Dependencies
- Depends on: CORE-005
- Blocks: LOC-010, PUSH-007, OFF-007, MED-008

## Definition of Done
- [ ] AC met, debug UI works, server-side override flow verified
