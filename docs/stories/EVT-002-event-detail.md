# EVT-002: Event detail (description, venue, RSVP)

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** event detail with description, venue, RSVP CTA
**So that** I have everything needed to attend

## Acceptance Criteria

### AC-1: Detail
**Given** I tap an event **When** detail loads **Then** title, description, venue (with map link), starts_at, capacity remaining, RSVP CTA visible.

### AC-2: Capacity full
**Given** capacity = 0 **When** detail renders **Then** RSVP CTA disabled with localized "Full" label.

### AC-3: Cross-cutting
**Given** description in entity content lang **When** rendering **Then** font + direction follow `event.lang`; translate affordance if differs.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Date in school timezone

## Files
- `hogwarts/features/events/views/event-detail-view.swift`
- `hogwarts/features/events/viewmodels/event-detail-viewmodel.swift`

## API Contract
- `GET /api/mobile/events/:id` — `{ id, title, body, lang, venue:{name, lat, lng}, starts_at, capacity, registered_count, my_rsvp }`

## i18n Keys
- `common.events.detail.venue`
- `common.events.detail.starts_at`
- `common.events.detail.capacity_full`
- `common.events.detail.rsvp`

## Tests
- `HogwartsTests/events/event-detail-tests.swift`

## Dependencies
- Depends on: EVT-001
- Blocks: EVT-004, EVT-005, EVT-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, content lang verified
