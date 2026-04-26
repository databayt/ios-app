# HOME-008: Notification Badges per Tile

**Epic**: HOME
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want unread counts on tiles (Messages, Announcements, Fees), so that I notice items needing attention.

## Acceptance Criteria
### AC-1: Badges render
**Given** I have 5 unread messages **When** Home renders **Then** Messages tile shows red `5` badge in trailing-top corner.

### AC-2: Badge clears
**Given** I open Messages and clear unreads **When** I return to Home **Then** the badge disappears within 1s.

### AC-3: Cross-cutting
Numbers in Arabic-Indic for `ar`. Badge ≥99 shows `99+`. RTL: badge moves to leading-top corner.

## Cross-Cutting Invariants
- [ ] Localized digits (Arabic-Indic in `ar`)
- [ ] RTL-tested (corner mirrors)
- [ ] schoolId predicate (counts scoped per tenant)
- [ ] Role-gated (badges hidden for tiles user can't access)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/home/views/home-tile-badge.swift`
- `hogwarts/features/home/viewmodels/home-badges-viewmodel.swift`
- `hogwarts/features/home/services/badge-counts-service.swift`

## API Contract
- `GET /api/mobile/badges` → `{ messages, announcements, fees, ... }`

## i18n Keys
- `home.badge.overflow` (e.g., "99+")

## Tests
- `HogwartsTests/home/tile-badge-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: HOME-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
