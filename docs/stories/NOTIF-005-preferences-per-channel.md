# NOTIF-005: Preferences (per channel)

**Epic**: NOTIF
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to toggle each notification channel (messages, attendance, grades, fees, announcements)
**So that** I receive only what I care about

## Acceptance Criteria

### AC-1: Toggle channel
**Given** Settings → Notifications **When** I toggle "Fees" off **Then** server updates preference; future fee notifications suppressed.

### AC-2: Defaults
**Given** first launch **When** preferences fetched **Then** all channels ON by default.

### AC-3: Cross-cutting
**Given** preferences mutation **When** sent **Then** request scoped to `school_id` + `user_id`; preview row uses entity content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested toggle list
- [ ] schoolId + userId on PATCH
- [ ] Audit logged

## Files
- `hogwarts/features/notifications/views/preferences-view.swift`
- `hogwarts/features/notifications/viewmodels/preferences-viewmodel.swift`
- `hogwarts/features/notifications/services/preferences-actions.swift`

## API Contract
- `GET /api/mobile/notifications/preferences` — `{ messages:bool, attendance:bool, grades:bool, fees:bool, announcements:bool, events:bool }`
- `PATCH /api/mobile/notifications/preferences` — partial update

## i18n Keys
- `notifications.prefs.title`
- `notifications.prefs.channel.messages`
- `notifications.prefs.channel.attendance`
- `notifications.prefs.channel.grades`
- `notifications.prefs.channel.fees`
- `notifications.prefs.channel.announcements`

## Tests
- `HogwartsTests/notifications/preferences-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: AUTH-006
- Blocks: NOTIF-006, NOTIF-007, NOTIF-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
