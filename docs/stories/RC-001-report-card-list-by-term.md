# RC-001: Report Card List by Term

**Epic**: REPORTCARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to see all available report cards grouped by term
**So that** I can browse historical academic records easily

## Acceptance Criteria

### AC-1: Grouped list
**Given** the user opens Report Cards **When** the screen loads **Then** report cards group by term with the latest term first; each row shows term name, year, status (draft/published/signed).

### AC-2: Empty state
**Given** no report cards exist **When** the screen loads **Then** an empty state with illustration and "No report cards yet" appears.

### AC-3: Status badge
**Given** a report card is unsigned by the guardian **When** rendered **Then** a badge "Needs signature" appears (guardian role only).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student / guardian
- [ ] Term names in `entity.lang`

## Files
- `hogwarts/features/reportcard/views/report-card-list-view.swift`
- `hogwarts/features/reportcard/viewmodels/report-card-list-viewmodel.swift`

## API Contract
- `GET /api/mobile/report-cards` — `{ report_cards: [{ id, term_name, year, status, signed_at? }] }`

## i18n Keys
- `results.reportcard.list_title`, `results.reportcard.empty`, `results.reportcard.needs_signature`

## Tests
- `HogwartsTests/reportcard/list-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: CORE-001
- Blocks: RC-002, RC-003, RC-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
