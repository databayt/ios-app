# EVT-006: Share event

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to share an event link
**So that** I can invite others

## Acceptance Criteria

### AC-1: Share sheet
**Given** EVT-002 detail **When** I tap share **Then** ShareLink presents title + universal link + date in entity content lang.

### AC-2: Cross-cutting
**Given** share opens externally **When** receiver taps **Then** universal link routes to in-app detail (or web fallback) with `school_id` enforced server-side.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId in universal link
- [ ] Entity content lang in shared text

## Files
- `hogwarts/features/events/helpers/share-builder.swift`
- `hogwarts/features/events/views/event-detail-view.swift`

## API Contract
- (consumes EVT-002 endpoint)

## i18n Keys
- `common.events.share.subject`

## Tests
- `HogwartsTests/events/share-tests.swift`

## Dependencies
- Depends on: EVT-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, deep-link round-trip verified
