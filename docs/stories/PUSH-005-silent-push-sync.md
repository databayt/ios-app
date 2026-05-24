# PUSH-005: Silent Push Handling for Sync Triggers

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** silent pushes to refresh my data without a UI alert
**So that** my unread counts and lists stay current without disturbing me

## Acceptance Criteria

### AC-1: content-available handler
**Given** an APNs payload with `content-available: 1` **When** received **Then** `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)` triggers a feature-specific delta sync and calls the completion handler within 30s.

### AC-2: No UI shown
**Given** silent push **When** processed **Then** no banner, sound, or badge update happens (server controls those separately).

### AC-3: Tenant-scoped
**Given** payload `school_id` matches current tenant **When** sync runs **Then** delta is fetched; mismatch → ignored.

## Cross-Cutting Invariants
- [ ] schoolId predicate (sync only for current tenant)
- [ ] Audit logged (silent sync run)

## Files
- `hogwarts/features/notifications/services/silent-push-handler.swift`
- `hogwarts/HogwartsApp.swift` — wire delegate method

## API Contract
- Reuses feature delta endpoints.

## i18n Keys
- None (no UI).

## Tests
- `HogwartsTests/features/notifications/silent-push-tests.swift` — handler dispatch, tenant guard, completion timing

## Dependencies
- Depends on: PUSH-001, OFF-002
- Blocks: none

## Definition of Done
- [ ] AC met, real-device silent push observed, completion <30s, parity preserved
