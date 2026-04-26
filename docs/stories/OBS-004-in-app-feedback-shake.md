# OBS-004: In-App Feedback (Shake to Report)

**Epic**: OBS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user (especially internal testers)
**I want** to shake the device and report a bug
**So that** filing feedback is frictionless

## Acceptance Criteria

### AC-1: Shake gesture opens form
**Given** the app is foregrounded
**When** the user shakes the device
**Then** a localized feedback form opens with screenshot attached

### AC-2: Submit attaches diagnostics
**Given** the form is submitted
**When** payload is built
**Then** session id, role, locale, tenant_id, recent logs attach (no PII)

### AC-3: Server receives + tracker links
**Given** submission succeeds
**When** the backend processes
**Then** a tracker issue is created with the diagnostics blob

## Cross-Cutting Invariants
- [ ] Localized strings
- [ ] No PII in payload
- [ ] schoolId tagged

## Files
- `hogwarts/core/observability/shake-feedback.swift`
- `hogwarts/features/feedback/views/feedback-form-view.swift`

## API Contract
- `POST /api/mobile/observability/feedback` — multipart `{ note, screenshot, diag }`

## i18n Keys
- `common.feedback.title`, `note`, `submit`, `submitted`

## Tests
- `HogwartsTests/observability/shake-feedback-tests.swift`

## Dependencies
- Depends on: OBS-002
- Blocks: —

## Definition of Done
- [ ] AC met, RTL verified, no PII verified
