# OBS-001: Sentry Crash Reporting

**Epic**: OBS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** Sentry capturing crashes and errors
**So that** I am alerted within minutes of incidents

## Acceptance Criteria

### AC-1: Crash → Sentry within 1 min
**Given** a debug crash from staging
**When** the app re-launches and uploads
**Then** the crash event is visible in Sentry within 1 minute

### AC-2: Symbolicated stack
**Given** dSYMs are uploaded on archive
**When** crashes appear
**Then** stacks are symbolicated

### AC-3: No PII attached
**Given** Sentry user context
**When** events post
**Then** only `tenant_id`, `role`, `app_locale` (NO name/email)

## Cross-Cutting Invariants
- [ ] Privacy: no PII
- [ ] schoolId tagged on every event

## Files
- `hogwarts/core/observability/sentry-bootstrap.swift`
- `hogwarts/scripts/upload-dsym.sh`

## API Contract
- (none — Sentry SDK)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/observability/sentry-tests.swift`

## Dependencies
- Depends on: —
- Blocks: OBS-002, OBS-006

## Definition of Done
- [ ] AC met, dSYM upload automated, no PII verified
