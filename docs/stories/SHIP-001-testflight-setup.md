# SHIP-001: TestFlight Setup + Beta Group

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** product team
**I want** TestFlight set up with a private beta group
**So that** we can test pre-release builds with real users

## Acceptance Criteria

### AC-1: TestFlight build accepted
**Given** an archive is uploaded
**When** processing completes
**Then** TestFlight accepts and the build is testable

### AC-2: Internal + external groups
**Given** TestFlight is configured
**When** groups are created
**Then** Internal group is set up; External group exists with ≥10 testers

### AC-3: Beta App Review pass
**Given** an external build is submitted for beta review
**When** review completes
**Then** the build is approved for external testing

## Cross-Cutting Invariants
- [ ] Localized release notes attached
- [ ] schoolId scoping unaffected

## Files
- `hogwarts/.github/workflows/testflight.yml`
- `docs/release/testflight-distribution.md`

## API Contract
- (none — App Store Connect API)

## i18n Keys
- (none)

## Tests
- Manual: TestFlight install on test device

## Dependencies
- Depends on: PERF-001, OBS-001
- Blocks: SHIP-002, SHIP-006, SHIP-007

## Definition of Done
- [ ] AC met, ≥10 testers active, beta review approved
