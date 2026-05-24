# SUB-S-002: Subscription Upgrade/Downgrade

**Epic**: SUBSCRIPTION-SAAS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As a** school admin
**I want** to upgrade or downgrade the subscription plan
**So that** I match capacity to actual school size

## Acceptance Criteria

### AC-1: Plan picker
**Given** the admin taps "Change plan"
**When** plans load
**Then** picker shows all eligible plans with localized name, price, features

### AC-2: Confirm change
**Given** a plan is selected
**When** admin confirms
**Then** server processes change, audit logs old→new, view reflects new plan

### AC-3: Downgrade with seat overage
**Given** seats_used > new plan's seats_total
**When** admin attempts downgrade
**Then** localized error blocks until seats are released

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `sales`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] Audit log on change

## Files
- `hogwarts/features/subscription/views/plan-picker-view.swift`
- `hogwarts/features/subscription/viewmodels/plan-picker-viewmodel.swift`
- `hogwarts/features/subscription/services/subscription-service.swift`

## API Contract
- `GET /api/mobile/subscription/plans` → `{ plans: [] }`
- `POST /api/mobile/subscription/change` — `{ plan_id }` → `{ subscription }`

## i18n Keys
- `sales.subscription.change_plan`, `confirm`, `downgrade_overage`

## Tests
- `HogwartsTests/subscription/upgrade-downgrade-tests.swift`

## Dependencies
- Depends on: SUB-S-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged
