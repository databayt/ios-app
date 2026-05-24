# DASH-S-001: Student Today Summary

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want a "today" card showing current/next class, attendance status, and pending tasks, so that I know what's next.

## Acceptance Criteria
### AC-1: Renders today snapshot
**Given** I am on dashboard **When** the today card loads **Then** I see current class (or "next class at HH:MM"), today's attendance status, and pending tasks count.

### AC-2: Cached when offline
**Given** I am offline **When** I open dashboard **Then** I see last-cached today data with stale banner.

### AC-3: Cross-cutting
Numbers locale-formatted. Class names in entity.lang. RTL card layout.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/student-today-summary-view.swift`
- `hogwarts/features/dashboard/viewmodels/student-dashboard-viewmodel.swift`
- `hogwarts/features/dashboard/services/dashboard-service.swift`

## API Contract
- `GET /api/mobile/dashboard` (role=student) → `{ today: { currentClass?, nextClass?, attendanceStatus, pendingTasks } }`

## i18n Keys
- `home.today.title`, `home.today.current_class`, `home.today.next_class`, `home.today.pending`

## Tests
- `HogwartsTests/dashboard/student-today-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-002 (existing routing), CORE-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
