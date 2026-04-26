# ATT-004: Badges Shelf (Gamification)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want a badges shelf for attendance milestones (perfect month, 10-day streak, etc.), so that progress feels rewarded.

## Acceptance Criteria
### AC-1: Earned + locked badges
**Given** I open Badges **When** the shelf renders **Then** I see earned badges in color and locked ones with criteria visible on tap.

### AC-2: Newly earned animation
**Given** I just earned a badge **When** I open the shelf **Then** the new badge animates with a confetti effect (suppressed under Reduce Motion).

### AC-3: Cross-cutting
Badge titles entity.lang. RTL grid order. Reduce Motion suppresses animation.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (badge claim)

## Files
- `hogwarts/features/attendance/views/badges-shelf.swift`
- `hogwarts/features/attendance/viewmodels/badges-viewmodel.swift`
- `hogwarts/features/attendance/services/badges-service.swift`

## API Contract
- `GET /api/mobile/attendance/badges` → `[{ id, title, description, earnedAt?, iconUrl, criteria }]`

## i18n Keys
- `attendance.badges.title`, `attendance.badges.locked`, `attendance.badges.criteria`, `attendance.badges.new`

## Tests
- `HogwartsTests/attendance/badges-tests.swift`
- Reduce-motion variant test

## Dependencies
- Depends on: ATT-003, SET-005
- Blocks: PROF-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
