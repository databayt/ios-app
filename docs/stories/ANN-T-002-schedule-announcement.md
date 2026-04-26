# ANN-T-002: Schedule announcement

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As an** admin
**I want** to schedule an announcement for future publish time
**So that** I can prepare messages in advance

## Acceptance Criteria

### AC-1: Schedule future
**Given** composer **When** I set `publish_at` to a future time and tap "Schedule" **Then** server stores it as scheduled; not visible to readers until time passes.

### AC-2: List + edit
**Given** I view "Scheduled" tab **When** I tap a row **Then** I can edit or cancel before publish.

### AC-3: Cross-cutting
**Given** scheduled time **When** server-side worker fires **Then** push notification sent in entity `lang` to scoped audience (ANN-T-003).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] Date picker uses `Locale.current` and school timezone
- [ ] schoolId on POST/GET
- [ ] Role gate (admin only)
- [ ] Audit logged on schedule, edit, cancel

## Files
- `hogwarts/features/announcements/views/schedule-announcement-view.swift`
- `hogwarts/features/announcements/viewmodels/scheduled-list-viewmodel.swift`
- `hogwarts/features/announcements/services/announcement-actions.swift` — `schedule(...)`

## API Contract
- `POST /api/mobile/announcements` with `publish_at` future
- `GET /api/mobile/announcements/scheduled` — list
- `PATCH /api/mobile/announcements/:id` — edit pre-publish
- `DELETE /api/mobile/announcements/:id` — cancel

## i18n Keys
- `messages.schedule.publish_at`
- `messages.schedule.tab_label`
- `messages.schedule.cancel`

## Tests
- `HogwartsTests/announcements/schedule-tests.swift`
- Timezone test, role-gate test

## Dependencies
- Depends on: ANN-T-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId verified, audit row exists
