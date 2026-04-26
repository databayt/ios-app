# SRCH-003: Search Results Scoped to Tenant + Role

**Epic**: F-SEARCH
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want search results filtered by my role (student sees own data, teacher sees own classes), so that I never see content I cannot access.

## Acceptance Criteria
### AC-1: Server-side enforcement
**Given** a search request **When** server queries Prisma **Then** WHERE clauses include `schoolId = jwt.schoolId` AND role-based filters (student → own; teacher → assigned classes; admin → all in tenant).

### AC-2: Client double-check
**Given** any returned result **When** rendered **Then** client verifies the result's `schoolId` matches TenantContext; mismatched results are hidden and reported (telemetry).

### AC-3: Empty result UX
**Given** zero permitted results **When** rendered **Then** an empty state with role-aware suggestion appears (e.g., teacher: "Try searching your classes").

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (double-enforced)
- [ ] Role-gated (server-side)
- [ ] Audit logged (telemetry on tenant mismatch)

## Files
- `hogwarts/features/search/services/search-service.swift` — client check
- `hogwarts/features/search/viewmodels/search-view-model.swift` — filter
- `hogwarts/features/search/views/search-empty-view.swift` — empty UI

## API Contract
- `GET /api/mobile/search` — server enforces role + tenant; returns only permitted

## i18n Keys
- `common.search.empty`
- `common.search.empty.teacher`
- `common.search.empty.student`
- `common.search.empty.guardian`

## Tests
- `HogwartsTests/search/search-scope-tests.swift`
- Cross-tenant smoke test

## Dependencies
- Depends on: SRCH-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
