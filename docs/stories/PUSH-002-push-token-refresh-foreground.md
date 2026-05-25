# PUSH-002: Token Refresh on App Foreground

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** my push token re-registered when the app foregrounds after long absence
**So that** APNs doesn't drop my device and I keep receiving notifications

## Acceptance Criteria

### AC-1: Foreground re-register
**Given** the app foregrounds after >24h background **When** observed **Then** `UIApplication.shared.registerForRemoteNotifications()` re-fires and the new token is sent via PUSH-001's flow.

### AC-2: Same-token suppression
**Given** the token is unchanged **When** the registrar runs **Then** the network call is suppressed (idempotent guard).

## Cross-Cutting Invariants
- [ ] schoolId predicate (token tagged with tenant)
- [ ] Audit logged (token refresh)

## Files
- `hogwarts/features/notifications/services/push-registrar.swift` — extend with foreground hook
- `hogwarts/HogwartsApp.swift` — observe `scenePhase == .active`

## API Contract
- Reuses `POST /api/mobile/notifications/register` (PUSH-001).

## i18n Keys
- None.

## Tests
- `HogwartsTests/features/notifications/push-foreground-tests.swift` — same-token suppression, change-token send

## Dependencies
- Depends on: PUSH-001
- Blocks: none

## Definition of Done
- [ ] AC met, 24h backgrounding test verified manually
