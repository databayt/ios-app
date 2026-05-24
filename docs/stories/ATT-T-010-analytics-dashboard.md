# ATT-T-010: Attendance Analytics Dashboard

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
As an admin, I want school-wide attendance analytics (trends, by class, by grade), so that I monitor health and report to leadership.

## Acceptance Criteria
### AC-1: Top-level KPIs
**Given** I open Analytics **When** the view loads **Then** I see this-term overall %, year-over-year delta, top/bottom 5 classes.

### AC-2: Drill-down filters
**Given** I select a grade or class **When** the filter applies **Then** charts and tables refresh scoped to that selection.

### AC-3: Export
**Given** I tap Export **When** the share sheet opens **Then** a CSV (per current filter) generates and shares.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`, `admin`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (admin only)
- [ ] Audit logged (export)

## Files
- `hogwarts/features/attendance/views/analytics-dashboard.swift`
- `hogwarts/features/attendance/viewmodels/analytics-viewmodel.swift`
- `hogwarts/features/attendance/services/analytics-service.swift`

## API Contract
- `GET /api/mobile/attendance/analytics?gradeId=...&classId=...` → `{ overallPct, yoy, top5, bottom5, series }`
- `GET /api/mobile/attendance/analytics/export.csv?...`

## i18n Keys
- `attendance.analytics.title`, `attendance.analytics.overall`, `attendance.analytics.yoy`, `attendance.analytics.top5`, `attendance.analytics.export`

## Tests
- `HogwartsTests/attendance/analytics-tests.swift`
- CSV export PII-scope test

## Dependencies
- Depends on: ATT-T-009
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
