# HOME-002: Widget Pages (Role-Aware)

**Epic**: HOME
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want paged tile groups whose default contents reflect my role, so that I see relevant features without configuration.

## Acceptance Criteria
### AC-1: Role-aware defaults
**Given** I am a Student **When** I land on Home **Then** page 1 shows tiles relevant to students (Timetable, Attendance, Grades, Messages, Fees, ID).

### AC-2: Page indicator + swipe
**Given** there are 2+ pages **When** I swipe **Then** the page indicator updates and tiles transition smoothly.

### AC-3: Cross-cutting
RTL swipe reverses semantically (next page is to the left). Tiles labeled in localized strings.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a — UI)
- [ ] Role-gated (defaults differ per role)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/home/views/home-widget-pages-view.swift`
- `hogwarts/features/home/views/home-grid-view.swift`
- `hogwarts/features/home/viewmodels/home-pages-viewmodel.swift`
- `hogwarts/features/home/services/home-defaults-service.swift`

## API Contract
- (none — defaults from local config)

## i18n Keys
- `home.tile.<feature>` (per tile), `home.page.indicator`

## Tests
- `HogwartsTests/home/widget-pages-tests.swift`
- Snapshot AR + EN per role variant

## Dependencies
- Depends on: HOME-001
- Blocks: HOME-003, HOME-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role variants verified, parity preserved
