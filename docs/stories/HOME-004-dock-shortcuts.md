# HOME-004: Dock Shortcuts

**Epic**: HOME
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want a 4-slot dock with role-aware default shortcuts, so that key actions are one tap away from any home page.

## Acceptance Criteria
### AC-1: 4 fixed slots
**Given** I am on Home **When** the dock renders **Then** exactly 4 atoms appear, fixed across pages.

### AC-2: Role-aware defaults
**Given** I am a Teacher **When** Home loads first time **Then** dock contains Schedule, Mark Attendance, Messages, Profile (replaceable later in HOME-003).

### AC-3: Cross-cutting
Dock layout flips in RTL. Tap target ≥44pt. Labels localized.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested (flipped order)
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (defaults differ)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/home/views/home-dock-view.swift`
- `hogwarts/features/home/services/dock-defaults-service.swift`

## API Contract
- (none)

## i18n Keys
- `home.dock.<role>.<slot>`

## Tests
- `HogwartsTests/home/dock-tests.swift`
- Snapshot AR + EN per role variant

## Dependencies
- Depends on: HOME-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role variants verified, parity preserved
