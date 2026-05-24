# OBS-006: User Properties (Role, School, Plan) for Segmented Analytics

**Epic**: OBS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** product manager
**I want** events tagged with role/school/plan
**So that** I can segment analytics

## Acceptance Criteria

### AC-1: User properties set on session
**Given** user authenticates
**When** session bootstraps
**Then** Sentry user context = `{ tenant_id, role, plan, app_locale }` (no PII)

### AC-2: Updates on tenant switch
**Given** the user switches tenant
**When** new context activates
**Then** properties update in-place

### AC-3: No PII enforced
**Given** linter
**When** code is changed
**Then** lint blocks setting name/email/phone in user properties

## Cross-Cutting Invariants
- [ ] No PII
- [ ] schoolId on every event

## Files
- `hogwarts/core/observability/user-properties.swift`
- `hogwarts/scripts/lint-user-properties.sh`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/observability/user-properties-tests.swift`

## Dependencies
- Depends on: OBS-001, OBS-002
- Blocks: SEC-003

## Definition of Done
- [ ] AC met, lint active, no PII verified, switch updates verified
