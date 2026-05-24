# PUSH-007: Provisional Auth — Non-Disruptive Onboarding

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** new user
**I want** the app to enable provisional notifications during onboarding
**So that** I receive trial notifications quietly and decide later whether to allow them prominently

## Acceptance Criteria

### AC-1: Provisional registration
**Given** first onboarding **When** the user reaches the relevant screen **Then** `requestAuthorization(options: [.provisional, ...])` is called without showing an alert.

### AC-2: Token send unchanged
**Given** provisional grant **When** APNs returns a token **Then** PUSH-001's flow runs identically.

### AC-3: Promote to full
**Given** the user later interacts with a provisional notification (View / Reply) **When** observed **Then** the system auto-promotes the auth level; no extra code path needed.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] Audit logged (provisional grant)

## Files
- `hogwarts/features/notifications/services/push-registrar.swift` — extend options
- `hogwarts/features/onboarding/views/notifications-onboarding-view.swift` — UX copy

## API Contract
- Reuses `POST /api/mobile/notifications/register` (PUSH-001).

## i18n Keys
- `notifications.provisional.title`, `notifications.provisional.body`

## Tests
- `HogwartsTests/features/notifications/provisional-tests.swift` — auth options, token flow

## Dependencies
- Depends on: PUSH-001, CORE-007 (feature flag)
- Blocks: none

## Definition of Done
- [ ] AC met, real-device verification of quiet delivery, AR + EN onboarding copy
