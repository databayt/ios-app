# DASH-AC-001: Accountant Finance KPIs

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [accountant]
**Multi-Tenant**: required

## User Story
As an accountant, I want collected/outstanding/overdue KPIs for the current term, so that I prioritize collections.

## Acceptance Criteria
### AC-1: 3 KPI cards
**Given** I open dashboard **When** the cards render **Then** I see Collected (this term), Outstanding, and Overdue >30d, each with currency formatting.

### AC-2: Tap drills down
**Given** I tap Overdue **When** navigation runs **Then** I land on the overdue invoices list pre-filtered.

### AC-3: Cross-cutting
Currency from TenantContext.currency. Arabic-Indic digits. RTL grid. Color thresholds WCAG AA.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `finance`, `banking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (accountant only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/accountant-finance-kpis.swift`
- `hogwarts/features/dashboard/viewmodels/accountant-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` (role=accountant) → `{ finance: { collected, outstanding, overdue30d, currency } }`

## i18n Keys
- `home.acc.collected`, `home.acc.outstanding`, `home.acc.overdue`, `home.acc.term`

## Tests
- `HogwartsTests/dashboard/accountant-kpis-tests.swift`
- Snapshot AR + EN; currency-formatting test

## Dependencies
- Depends on: DASH-002
- Blocks: DASH-AC-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, currency-correct, parity preserved
