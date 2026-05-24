# DASH-A-001: Admin School KPIs

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
As an admin, I want top-line KPIs (enrollment, attendance %, fees collected, active staff) at a glance, so that I monitor school health.

## Acceptance Criteria
### AC-1: 4 KPI cards
**Given** I open dashboard **When** the KPI grid renders **Then** I see Enrollment, Attendance %, Fees Collected (this term), Active Staff with delta vs last term.

### AC-2: Tap drills down
**Given** I tap a KPI **When** navigation runs **Then** I land on the related feature with the same time-window filter applied.

### AC-3: Cross-cutting
Currency uses TenantContext.currency. Arabic-Indic digits. RTL grid. Numbers locale-formatted.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `admin`, `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (admin only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/admin-kpis-grid.swift`
- `hogwarts/features/dashboard/viewmodels/admin-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` (role=admin) → `{ kpis: { enrollment, attendancePct, feesCollected, activeStaff, deltas } }`

## i18n Keys
- `home.admin.kpi.enrollment`, `home.admin.kpi.attendance`, `home.admin.kpi.fees_collected`, `home.admin.kpi.active_staff`, `home.admin.kpi.delta`

## Tests
- `HogwartsTests/dashboard/admin-kpis-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-002
- Blocks: DASH-A-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
