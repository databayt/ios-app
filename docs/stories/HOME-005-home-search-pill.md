# HOME-005: Home Search Pill

**Epic**: HOME
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want a single search entry on Home, so that I can find anything (people, classes, messages, files) from one place.

## Acceptance Criteria
### AC-1: Pill expands to search
**Given** I tap the pill **When** the keyboard appears **Then** a unified search screen opens with recent queries.

### AC-2: Results grouped
**Given** I type "math" **When** results return **Then** they group by section (People, Classes, Messages, Library) with role-appropriate visibility.

### AC-3: Cross-cutting
RTL placeholder reads RTL. Recent queries stored locally per user. Empty state uses localized copy.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (search scoped to current tenant)
- [ ] Role-gated (results filtered by role)
- [ ] Audit logged (n/a — read-only)

## Files
- `hogwarts/features/home/views/home-search-pill-view.swift`
- `hogwarts/features/home/views/universal-search-view.swift`
- `hogwarts/features/home/services/search-service.swift`

## API Contract
- `GET /api/mobile/search?q=...` → `{ groups: [{ kind, items: [...] }] }`

## i18n Keys
- `home.search.placeholder`, `home.search.recent`, `home.search.empty`, `home.search.group.<kind>`

## Tests
- `HogwartsTests/home/search-pill-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: HOME-002
- Blocks: HOME-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
