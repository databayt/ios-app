# RC-002: Report Card Detail View

**Epic**: REPORTCARD
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to view a report card's subjects, grades, and teacher comments
**So that** I can review the full term's academic results

## Acceptance Criteria

### AC-1: Sections render
**Given** a report card is opened **When** the detail loads **Then** the screen shows header (student, term, year), subject table (subject, grade, comment), and overall remarks.

### AC-2: Comments in author lang
**Given** a homeroom teacher's remark is in Arabic **When** the app is in English **Then** the remark renders with Arabic font + RTL direction with a Translate affordance.

### AC-3: Locked actions
**Given** the report card is in `draft` state **When** opened **Then** PDF, share, and sign actions are disabled with explanatory tooltip.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Comments in `entity.lang`

## Files
- `hogwarts/features/reportcard/views/report-card-detail-view.swift`
- `hogwarts/features/reportcard/viewmodels/report-card-detail-viewmodel.swift`
- `hogwarts/features/reportcard/models/report-card.swift`

## API Contract
- `GET /api/mobile/report-cards/:id` — `{ id, student, term, subjects: [...], remarks, lang, status }`

## i18n Keys
- `results.reportcard.subjects`, `results.reportcard.remarks`, `results.reportcard.draft_locked`

## Tests
- `HogwartsTests/reportcard/detail-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: RC-001
- Blocks: RC-003, RC-005, RC-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
