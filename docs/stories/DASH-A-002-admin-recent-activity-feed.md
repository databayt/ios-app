# DASH-A-002: Admin Recent Activity Feed

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
As an admin, I want a recent-activity feed (announcements, enrollments, payments, leaves), so that I know what changed today.

## Acceptance Criteria
### AC-1: Last 20 events
**Given** dashboard loads **When** the feed renders **Then** I see the latest 20 audit-log events with type icon, actor, target, and timestamp.

### AC-2: Filter chips
**Given** I tap a filter chip (e.g., Payments) **When** the list filters **Then** only matching events show.

### AC-3: Cross-cutting
Times relative-localized. Actor names in entity.lang. RTL chip order reverses. schoolId scopes the feed.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `admin`)
- [ ] RTL-tested
- [ ] schoolId predicate (audit log scoped)
- [ ] Role-gated (admin only)
- [ ] Audit logged (n/a — read-only)

## Files
- `hogwarts/features/dashboard/views/admin-activity-feed.swift`
- `hogwarts/features/dashboard/viewmodels/admin-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard/activity?type=...&limit=20` → `[{ id, type, actor, target, at }]`

## i18n Keys
- `home.admin.activity.title`, `home.admin.activity.filter.<type>`, `home.admin.activity.empty`

## Tests
- `HogwartsTests/dashboard/admin-activity-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-A-001, CORE-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
