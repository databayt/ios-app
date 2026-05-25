# PUSH-004: Deep-Link Routing from Notification

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user tapping a notification
**I want** to land on the exact relevant detail screen
**So that** I don't have to navigate from the dashboard

## Acceptance Criteria

### AC-1: Payload routing
**Given** a notification payload contains `{ school_id, type, entity_id }` **When** tapped **Then** `NotificationNavigationState` enqueues a route and the App router pushes the corresponding detail screen.

### AC-2: Tenant verification
**Given** `school_id` in payload differs from current `TenantContext.currentSchoolId` **When** observed **Then** the user is prompted to switch schools before routing.

### AC-3: Cold-start routing
**Given** the app is cold-launched from a notification **When** `application(_:didFinishLaunchingWithOptions:)` reads the launch options **Then** routing waits for sign-in to complete then dispatches.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] schoolId predicate (cross-tenant guard)
- [ ] RTL-tested
- [ ] Audit logged (deep link invoked)

## Files
- `hogwarts/features/notifications/state/notification-navigation-state.swift` — extend with route enum
- `hogwarts/HogwartsApp.swift` — wire didReceiveResponse

## API Contract
- None (consumes payload).

## i18n Keys
- `notifications.deeplink.switch_school_prompt`

## Tests
- `HogwartsTests/features/notifications/deep-link-tests.swift` — route dispatch, cross-tenant guard, cold-start

## Dependencies
- Depends on: PUSH-003, OFF-006 (school switch)
- Blocks: none

## Definition of Done
- [ ] AC met, real-device cold-start verified, cross-tenant guard verified
