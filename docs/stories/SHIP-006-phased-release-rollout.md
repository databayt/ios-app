# SHIP-006: Phased Release Rollout Strategy

**Epic**: SHIP
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** phased release at 1% → 10% → 50% → 100%
**So that** issues are caught before reaching all users

## Acceptance Criteria

### AC-1: Phased on first day
**Given** an approved release
**When** rollout starts
**Then** Phased Release is enabled at 1%

### AC-2: Promotion gates
**Given** sentinel metrics (crash-free, latency, MetricKit)
**When** they pass thresholds
**Then** maintainers manually promote to next phase

### AC-3: Halt + rollback playbook
**Given** a regression detected
**When** halt is triggered
**Then** rollout halts and a hotfix workflow is documented

## Cross-Cutting Invariants
- [ ] OBS metrics tracked per phase
- [ ] schoolId-aware monitoring (no tenant-specific surprises)

## Files
- `docs/release/phased-rollout-playbook.md`

## API Contract
- (App Store Connect)

## i18n Keys
- (none)

## Tests
- Manual rehearsal documented

## Dependencies
- Depends on: SHIP-001, OBS-003
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, playbook reviewed, gates documented
