# EVT-004: Register / RSVP

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [guardian, student]
**Multi-Tenant**: required

## User Story
**As a** guardian or student
**I want** to RSVP to an event
**So that** my place is reserved

## Acceptance Criteria

### AC-1: RSVP
**Given** event with capacity **When** I tap RSVP **Then** server records; capacity decrements; success toast.

### AC-2: Cancel
**Given** RSVP'd **When** I tap "Cancel RSVP" **Then** server unregisters; capacity restored.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** scoped to `school_id`; audit `{ action:"event.rsvp", actor }`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested toast
- [ ] schoolId on POST
- [ ] Audit logged
- [ ] Role gate (guardian, student)

## Files
- `hogwarts/features/events/services/event-actions.swift` — `rsvp(id)`, `cancelRsvp(id)`
- `hogwarts/features/events/views/event-detail-view.swift` — RSVP button

## API Contract
- `POST /api/mobile/events/:id/register` — `{} → { rsvp_id, status }`
- `DELETE /api/mobile/events/:id/register` — cancel

## i18n Keys
- `common.events.rsvp.confirm`
- `common.events.rsvp.cancel`
- `common.events.rsvp.success`

## Tests
- `HogwartsTests/events/event-rsvp-tests.swift`
- Capacity-full test

## Dependencies
- Depends on: EVT-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
