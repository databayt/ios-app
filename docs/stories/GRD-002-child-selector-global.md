# GRD-002: Child selector (global app context)

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** a global child selector that scopes attendance, grades, fees, timetable
**So that** I switch context easily

## Acceptance Criteria

### AC-1: Selector
**Given** Children list **When** I tap a child **Then** active child set globally; toolbar shows current child + dropdown to switch.

### AC-2: Scopes views
**Given** active child changes **When** I open Attendance/Grades/Fees/Timetable **Then** views filter by child.

### AC-3: Cross-school switch
**Given** I pick a child in another school **When** active **Then** `TenantContext.switchSchool` invoked; caches invalidated; tenant currency/lang updated.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested selector
- [ ] schoolId switches via TenantContext
- [ ] Caches keyed by `<schoolId>:<childId>`
- [ ] Role gate (guardian only)

## Files
- `hogwarts/core/state/active-child-context.swift` — `@Observable`
- `hogwarts/features/guardian/views/child-selector-view.swift`
- `hogwarts/core/auth/tenant-context.swift` — `switchSchool` already exists

## API Contract
- (consumes `/guardian/children/:childId/{attendance,grades,fees,timetable}`)

## i18n Keys
- `profile.child_selector.title`
- `profile.child_selector.switch`
- `profile.child_selector.current`

## Tests
- `HogwartsTests/guardian/child-selector-tests.swift`
- Cross-school switch test, cache invalidation test

## Dependencies
- Depends on: GRD-001, AUTH-006
- Blocks: FEE-001, FEE-002, FEE-003, GRD-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, cross-school invalidation verified
