# EVT-003: Calendar view

**Epic**: EVENTS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** a month/week calendar with events plotted
**So that** I can plan around dates

## Acceptance Criteria

### AC-1: Month grid
**Given** Events tab → Calendar **When** loaded **Then** month grid shows current month with event dots.

### AC-2: Day drill-down
**Given** I tap a day **When** drilled **Then** events for that day listed; tap → EVT-002.

### AC-3: Cross-cutting
**Given** locale = `ar-SA` **When** grid renders **Then** week starts Saturday/Sunday per locale; RTL flip; Arabic-Indic numbers in cells.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested grid
- [ ] schoolId predicate
- [ ] Locale-aware first-day-of-week
- [ ] School timezone

## Files
- `hogwarts/features/events/views/events-calendar-view.swift`
- `hogwarts/features/events/viewmodels/events-calendar-viewmodel.swift`

## API Contract
- (consumes EVT-001 with from/to month)

## i18n Keys
- `common.calendar.month_title`
- `common.calendar.weekday.short`

## Tests
- `HogwartsTests/events/events-calendar-tests.swift`
- RTL grid test, locale week-start test

## Dependencies
- Depends on: EVT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, locale week-start verified
