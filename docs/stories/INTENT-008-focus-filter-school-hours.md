# INTENT-008: Focus Filter (School Hours)

**Epic**: F-INTENTS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Focus Filter "School Hours" that hides non-school content and silences extra notifications, so that I can focus during school time.

## Acceptance Criteria
### AC-1: Filter applies
**Given** the user enables the "School Hours" Focus **When** the app is opened **Then** non-essential UI sections (achievements, social) collapse, and only academic notifications render.

### AC-2: Per-role config
**Given** the role-aware Focus configuration **When** teacher vs. student vs. guardian uses it **Then** filter rules adapt: teacher sees attendance + messages; student sees timetable + assignments; guardian sees announcements + fees.

### AC-3: Cross-tenant safety
**Given** the focus is active **When** notifications arrive from a different school **Then** they remain silenced (Focus does not leak cross-tenant data).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (filter respects TenantContext)
- [ ] Role-gated rules

## Files
- `hogwarts/core/intents/focus-filter-school-hours.swift` — SetFocusFilterIntent
- `hogwarts/core/intents/focus-config.swift` — config struct
- `hogwarts/app/hogwarts-app.swift` — observe filter

## API Contract
None — local OS Focus integration.

## i18n Keys
- `home.focus.schoolHours.title`
- `home.focus.schoolHours.subtitle`
- `home.focus.schoolHours.option.notifications`

## Tests
- `HogwartsTests/intents/focus-filter-tests.swift`

## Dependencies
- Depends on: INTENT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
