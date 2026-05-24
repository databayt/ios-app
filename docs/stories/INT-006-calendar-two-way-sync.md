# INT-006: System Calendar Two-Way Sync

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want my school timetable to subscribe in iOS Calendar via ICS, so that schedule updates flow automatically without per-event taps.

## Acceptance Criteria
### AC-1: Subscribe via ICS
**Given** the timetable settings **When** user taps "Subscribe to Calendar" **Then** an ICS URL (signed, tenant-scoped, 30-day expiry) opens in Calendar's subscription handler.

### AC-2: Updates propagate
**Given** an admin changes a class time on the web **When** iOS Calendar refreshes **Then** the new time appears within the next sync window.

### AC-3: Tenant isolation
**Given** user switches to a different school **When** ICS URL is generated **Then** the new URL embeds the new schoolId; old URL becomes invalid on token refresh.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (signed URL embeds tenant)
- [ ] Audit logged (calendar.subscribed)

## Files
- `hogwarts/features/timetable/services/calendar-subscription-service.swift` — URL gen
- `hogwarts/features/timetable/views/timetable-settings-view.swift` — CTA
- `hogwarts/core/network/api-client.swift` — fetch signed URL

## API Contract
- `POST /api/mobile/timetable/ics-url` — returns `{ url, expiresAt }` (signed, scoped)
- Backend must serve the ICS feed (P2 backend ticket)

## i18n Keys
- `common.calendar.subscribe`
- `common.calendar.subscribed`
- `common.calendar.subscribeError`
- `common.calendar.urlExpired`

## Tests
- `HogwartsTests/integration/calendar-subscription-tests.swift`
- Multi-tenant URL isolation test

## Dependencies
- Depends on: INT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
