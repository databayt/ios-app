# NOTIF-001: In-app notifications list

**Epic**: NOTIF
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** an in-app notifications list
**So that** I can review activity (messages, attendance, grades, fees, announcements)

## Acceptance Criteria

### AC-1: List loads
**Given** I open Notifications **When** list fetches **Then** rows show icon + title + body preview + relative time, sorted desc.

### AC-2: Pull to refresh + paging
**Given** list visible **When** I pull-to-refresh or scroll bottom **Then** newest fetched / older paged in.

### AC-3: Cross-cutting
**Given** entity content lang differs from app lang **When** rendering body preview **Then** font + direction follow `notif.entity_lang`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] RTL-tested
- [ ] schoolId predicate on FetchDescriptor
- [ ] Entity content lang per row

## Files
- `hogwarts/features/notifications/views/notifications-list-view.swift`
- `hogwarts/features/notifications/viewmodels/notifications-viewmodel.swift`
- `hogwarts/features/notifications/models/notification-model.swift` — `@Model` with `schoolId`, `entity_lang`

## API Contract
- `GET /api/mobile/notifications?cursor=...&limit=20` — `[ { id, channel, title, body, entity_type, entity_id, entity_lang, created_at, read_at? } ]`

## i18n Keys
- `notifications.list.title`
- `notifications.list.empty`
- `notifications.row.relative_time.now`

## Tests
- `HogwartsTests/notifications/list-viewmodel-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: NOTIF-002, NOTIF-003, NOTIF-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
