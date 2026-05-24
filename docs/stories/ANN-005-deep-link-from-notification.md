# ANN-005: Deep-link from notification

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** tapping a push/in-app notification to open the matching announcement
**So that** I land on the right content with one tap

## Acceptance Criteria

### AC-1: Push tap → detail
**Given** I receive an APNs payload `{ type:"announcement", id, school_id }` **When** I tap **Then** app routes to ANN-002 detail with the id.

### AC-2: Cold start
**Given** app launched from notification **When** session restored **Then** route resolves after auth + tenant context loads.

### AC-3: Cross-tenant guard
**Given** push `school_id ≠ active school` **When** routing **Then** app prompts to switch school (per multitenancy.md).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] schoolId guard on route
- [ ] No data leak across tenants
- [ ] RTL-tested route

## Files
- `hogwarts/core/routing/deep-link-router.swift` — `announcement://` handler
- `hogwarts/features/announcements/views/announcement-detail-view.swift` — accepts deep-link id
- `hogwarts/core/auth/tenant-context.swift` — `switchSchool` prompt

## API Contract
- (consumes ANN-002 endpoint)

## i18n Keys
- `messages.deep_link.switch_school_prompt`
- `common.continue`
- `common.cancel`

## Tests
- `HogwartsTests/announcements/deep-link-tests.swift`
- Cold-start path test, cross-tenant rejection test

## Dependencies
- Depends on: ANN-002, NOTIF-004, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, schoolId scope verified, cold-start works
