# SEC-003: Jailbreak Detection + Soft Warning

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** a soft warning if the device appears jailbroken
**So that** users are informed of risk without breaking legitimate use

## Acceptance Criteria

### AC-1: Heuristic detection
**Given** common JB indicators (suspicious paths, sandbox escape)
**When** evaluated at launch
**Then** a localized warning banner appears on settings

### AC-2: Soft only (no hard block)
**Given** detection true
**When** the user dismisses
**Then** the app continues to function

### AC-3: Telemetry tag
**Given** detection true
**When** events are logged
**Then** `device_jailbroken=true` tag attaches to OBS events (no PII)

## Cross-Cutting Invariants
- [ ] Localized strings
- [ ] No PII in telemetry tag

## Files
- `hogwarts/core/security/jailbreak-detector.swift`
- `hogwarts/features/settings/views/security-warning-banner.swift`

## API Contract
- (none)

## i18n Keys
- `common.security.device_warning`

## Tests
- `HogwartsTests/security/jailbreak-detection-tests.swift`

## Dependencies
- Depends on: OBS-006
- Blocks: —

## Definition of Done
- [ ] AC met, soft warning verified, telemetry tag verified
