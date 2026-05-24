# DASH-G-001: Guardian Child Selector + Summary

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
As a guardian with multiple children, I want a child selector and a summary card per selected child, so that I track each child quickly.

## Acceptance Criteria
### AC-1: Selector at top
**Given** I have 2+ linked children **When** I open dashboard **Then** I see a horizontal child chip selector with avatar+name; tapping switches summary content.

### AC-2: Summary
**Given** I select child A **When** the summary renders **Then** I see today's attendance, GPA, next class, and pending fees for child A.

### AC-3: Cross-cutting
Single child: no selector chrome. RTL chip order reverses. Names in entity.lang. Multi-tenant: only children in current schoolId.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `attendance`, `finance`)
- [ ] RTL-tested
- [ ] schoolId predicate (only children in current school)
- [ ] Role-gated (guardian only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/guardian-child-selector.swift`
- `hogwarts/features/dashboard/views/guardian-summary-view.swift`
- `hogwarts/features/dashboard/viewmodels/guardian-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` (role=guardian) → `{ children: [{ id, name, avatar, summary: { ... } }] }`

## i18n Keys
- `home.guardian.select_child`, `home.guardian.summary`, `home.guardian.today_attendance`, `home.guardian.fees_due`

## Tests
- `HogwartsTests/dashboard/guardian-selector-tests.swift`
- Snapshot AR + EN per child count (1 vs 3)

## Dependencies
- Depends on: DASH-002
- Blocks: DASH-G-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
