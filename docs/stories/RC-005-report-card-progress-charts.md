# RC-005: Report Card Progress Charts (Term over Term)

**Epic**: REPORTCARD
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** charts that compare report card outcomes term over term
**So that** I can see academic trajectory across the year

## Acceptance Criteria

### AC-1: Multi-term chart
**Given** at least 2 published report cards **When** the charts screen loads **Then** a line chart shows overall GPA per term with locale-formatted labels.

### AC-2: Subject breakdown
**Given** subjects are consistent across terms **When** the user taps a subject **Then** a per-subject trend line appears.

### AC-3: Empty state
**Given** less than 2 report cards exist **When** the screen loads **Then** an empty state replaces the chart, suggesting they return after the next term.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`)
- [ ] RTL-tested (chart axes mirror)
- [ ] schoolId predicate
- [ ] Role-gated to guardian
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/reportcard/views/progress-charts-view.swift`
- `hogwarts/features/reportcard/viewmodels/progress-charts-viewmodel.swift`

## API Contract
- `GET /api/mobile/report-cards?include=trend` — `{ trend: [{ term, gpa, by_subject: [...] }] }`

## i18n Keys
- `results.progress.title`, `results.progress.empty`, `results.progress.by_subject`

## Tests
- `HogwartsTests/reportcard/progress-charts-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: RC-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
