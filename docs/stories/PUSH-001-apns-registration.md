# PUSH-001: APNs Registration + Token Send

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** the app to register for push notifications and send my device token to the backend
**So that** the school can deliver announcements, messages, and alerts

## Acceptance Criteria

### AC-1: Permission prompt
**Given** the user signs in for the first time **When** the inbox or notifications screen first opens **Then** a localized rationale precedes the system permission prompt.

### AC-2: Token sent
**Given** APNs returns a token **When** received **Then** `POST /api/mobile/notifications/register` is called with `{ device_token, device_id, platform: "ios", locale, app_version }`.

### AC-3: Tenant-tagged
**Given** the request **When** sent **Then** `schoolId` is included so the backend tags the device per tenant.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] schoolId predicate (token registration tenant-scoped)
- [ ] Audit logged (registration event)

## Files
- `hogwarts/features/notifications/services/push-registrar.swift`
- `hogwarts/HogwartsApp.swift` — `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`

## API Contract
- `POST /api/mobile/notifications/register` — request `{ device_token, device_id, platform, locale, app_version }`; response `{ id, registered_at }`

## i18n Keys
- `notifications.permission.rationale_title`, `notifications.permission.rationale_body`

## Tests
- `HogwartsTests/features/notifications/push-registrar-tests.swift` — registration payload, permission gating

## Dependencies
- Depends on: CORE-001, CORE-005
- Blocks: PUSH-002, PUSH-003

## Definition of Done
- [ ] AC met, real-device token registers in staging, parity preserved
