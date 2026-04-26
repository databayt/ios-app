# GRADE-004: Grade Trend Charts (by Term, by Subject)

**Epic**: GRADES
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** charts that show grade trends across terms and subjects
**So that** I can spot improvements or regressions visually

## Acceptance Criteria

### AC-1: Term trend line
**Given** at least 2 terms of data **When** the chart renders **Then** a line chart shows term-over-term GPA with locale-formatted axis labels.

### AC-2: Subject bar chart
**Given** subjects with grades **When** the bar chart renders **Then** subjects appear as bars sorted by current score; chart mirrors in RTL.

### AC-3: Empty state
**Given** less than 2 terms **When** opened **Then** an empty state message + illustration appears instead of an empty chart.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`)
- [ ] RTL-tested (chart axis flips)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Numbers locale-formatted

## Files
- `hogwarts/features/grades/views/grade-charts-view.swift`
- `hogwarts/features/grades/viewmodels/grade-charts-viewmodel.swift`

## API Contract
- `GET /api/mobile/grades/summary/:id?include=trend` — `{ trend: [{ term, gpa }], by_subject: [...] }`

## i18n Keys
- `results.chart.term_trend`, `results.chart.by_subject`, `results.chart.empty`

## Tests
- `HogwartsTests/grades/grade-charts-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: GRADE-003
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
