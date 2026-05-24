# EVT-001: Events list (by date, type)

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** a list of events filtered by date/type
**So that** I can browse what's upcoming

## Acceptance Criteria

### AC-1: List
**Given** events exist **When** I open Events **Then** rows show title, date, venue, type; default sort = upcoming first.

### AC-2: Filter
**Given** list visible **When** I filter by type or date range **Then** results scope.

### AC-3: Cross-cutting
**Given** dates **When** rendered **Then** locale-formatted in school timezone; titles in entity content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang for titles
- [ ] Dates use school timezone

## Files
- `hogwarts/features/events/views/events-list-view.swift`
- `hogwarts/features/events/viewmodels/events-list-viewmodel.swift`
- `hogwarts/features/events/models/event-model.swift` — `@Model` with `schoolId`, `lang`, `timezone`

## API Contract
- `GET /api/mobile/events?from=...&to=...&type=...` — `[ { id, title, lang, type, starts_at, venue } ]`

## i18n Keys
- `common.events.title`
- `common.events.filter.type`
- `common.events.empty`

## Tests
- `HogwartsTests/events/events-list-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: EVT-002, EVT-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
