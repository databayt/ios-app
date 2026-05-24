# PUSH-006: Rich Notifications — Image Attachments via Service Extension

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** notifications to display images (e.g., chat photo, school banner)
**So that** previews are richer and engagement is higher

## Acceptance Criteria

### AC-1: NSE target
**Given** the project **When** built **Then** a `Notification Service Extension` target downloads `mutable-content` payload's `image_url`, attaches it as `UNNotificationAttachment`, and calls the content handler.

### AC-2: Tenant-scoped image fetch
**Given** `image_url` is signed and tenant-scoped **When** fetched **Then** schoolId is implicit in the signed URL (server enforces).

### AC-3: Fallback
**Given** download fails or times out **When** the handler returns **Then** the notification displays without image, never blank.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] schoolId predicate (signed URL)
- [ ] No PII logged

## Files
- `HogwartsNotificationService/notification-service.swift` — NSE
- `project.yml` — register NSE target

## API Contract
- Consumes signed URLs from notification payload.

## i18n Keys
- None.

## Tests
- `HogwartsNotificationServiceTests/nse-tests.swift` — fixture payload, attachment build, timeout fallback

## Dependencies
- Depends on: PUSH-001, MED-007
- Blocks: PUSH-008

## Definition of Done
- [ ] AC met, real-device image push verified, timeout fallback verified
