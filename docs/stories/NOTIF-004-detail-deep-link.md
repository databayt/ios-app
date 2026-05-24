# NOTIF-004: Notification detail / deep-link

**Epic**: NOTIF
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** tapping a notification to open the related entity (message, grade, fee, announcement)
**So that** I act on the notification with one tap

## Acceptance Criteria

### AC-1: Route by entity_type
**Given** notification `entity_type` ∈ {announcement, message, attendance, grade, fee, event} **When** tapped **Then** app routes to the correct feature view with `entity_id`.

### AC-2: Auto mark-read
**Given** I open via tap **When** detail loads **Then** notification is marked read automatically (NOTIF-002 path).

### AC-3: Cross-tenant guard
**Given** notification `school_id ≠ active school` **When** tap **Then** prompt to switch school; else route.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested route
- [ ] schoolId guard on route
- [ ] Entity content lang loaded by detail view

## Files
- `hogwarts/core/routing/deep-link-router.swift` — entity-type → route map
- `hogwarts/features/notifications/views/notifications-list-view.swift` — tap handler

## API Contract
- (consumes feature-specific endpoints; no new API)

## i18n Keys
- `notifications.deep_link.switch_school_prompt`
- `common.continue`

## Tests
- `HogwartsTests/notifications/deep-link-tests.swift`
- Cross-tenant rejection test

## Dependencies
- Depends on: NOTIF-001, NOTIF-002, AUTH-006
- Blocks: ANN-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
