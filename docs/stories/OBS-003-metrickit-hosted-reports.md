# OBS-003: MetricKit Hosted Reports

**Epic**: OBS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** MetricKit daily payloads forwarded to hosted analytics
**So that** I see performance trends from real users

## Acceptance Criteria

### AC-1: Receive payloads
**Given** MXMetricManager subscribed
**When** Apple delivers daily payload
**Then** the app forwards to backend (or Sentry/MetricKit Cloud)

### AC-2: Aggregation dashboard
**Given** payloads in storage
**When** dashboard renders
**Then** aggregated launch, hang, energy metrics visible

### AC-3: Privacy
**Given** payload payload
**When** forwarded
**Then** no PII attached, scoped per `tenant_id`

## Cross-Cutting Invariants
- [ ] No PII
- [ ] schoolId tagged

## Files
- `hogwarts/core/observability/metric-kit-receiver.swift`
- `docs/observability/metrickit-dashboard.md`

## API Contract
- `POST /api/mobile/observability/metrickit` — payload

## i18n Keys
- (none)

## Tests
- `HogwartsTests/observability/metrickit-tests.swift`

## Dependencies
- Depends on: OBS-002
- Blocks: PERF-004

## Definition of Done
- [ ] AC met, dashboard reading payloads, privacy verified
