# EVT-T-001: Create event (admin)

**Epic**: EVENTS
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As an** admin
**I want** to create an event with venue, capacity, type, lang
**So that** the school community can register

## Acceptance Criteria

### AC-1: Create
**Given** Events tab **When** I tap "+ New" and fill title, body, venue, starts_at, capacity, type, lang **Then** event published; appears in EVT-001 list.

### AC-2: Validation
**Given** missing required fields **When** publish tapped **Then** localized validation errors.

### AC-3: Cross-cutting
**Given** create **When** sent **Then** `school_id` enforced; audit `{ action:"event.create" }`; event lang separate from author UI lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested form
- [ ] schoolId on POST
- [ ] Audit logged
- [ ] Role gate (admin only)
- [ ] Stored `lang` separate from author's UI

## Files
- `hogwarts/features/events/views/admin-create-event-view.swift`
- `hogwarts/features/events/viewmodels/admin-create-event-viewmodel.swift`
- `hogwarts/features/events/services/event-actions.swift` — `create(...)`

## API Contract
- `POST /api/mobile/events` — `{ title, body, lang, type, venue, starts_at, capacity } → { id }` (verify backend)

## i18n Keys
- `common.events.author.new`
- `common.events.author.venue`
- `common.events.author.capacity`
- `common.events.author.type`
- `common.events.author.publish`

## Tests
- `HogwartsTests/events/admin-create-tests.swift`
- Role-gate test, multi-tenant isolation

## Dependencies
- Depends on: AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
