# NOTIF-007: Channel groups (subscribe/unsubscribe)

**Epic**: NOTIF
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to subscribe/unsubscribe from school-defined topic groups (sports, drama, parents-grade-9)
**So that** I follow only relevant streams

## Acceptance Criteria

### AC-1: List groups
**Given** Settings → Channel Groups **When** loaded **Then** I see school-defined groups with subscribe toggle.

### AC-2: Unsubscribe
**Given** subscribed **When** I toggle off **Then** unsubscribed server-side; future notifications in that group suppressed.

### AC-3: Cross-cutting
**Given** group is school-scoped **When** fetched **Then** only `current school's` groups visible; group name renders in entity content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested
- [ ] schoolId predicate on fetch
- [ ] Entity content lang for group names

## Files
- `hogwarts/features/notifications/views/channel-groups-view.swift`
- `hogwarts/features/notifications/viewmodels/channel-groups-viewmodel.swift`
- `hogwarts/features/notifications/models/channel-group-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/notifications/groups` — `[ { id, name, lang, subscribed } ]`
- `POST /api/mobile/notifications/groups/:id/subscribe`
- `DELETE /api/mobile/notifications/groups/:id/subscribe`

## i18n Keys
- `notifications.groups.title`
- `notifications.groups.empty`
- `notifications.groups.subscribed`

## Tests
- `HogwartsTests/notifications/channel-groups-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: NOTIF-005
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
