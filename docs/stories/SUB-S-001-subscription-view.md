# SUB-S-001: Subscription View (Plan, Billing, Seats)

**Epic**: SUBSCRIPTION-SAAS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As a** school admin
**I want** to see my school's current SaaS plan, next billing date, and seat usage
**So that** I can manage budget and capacity

## Acceptance Criteria

### AC-1: Render current plan
**Given** the admin opens the Subscription screen
**When** data loads
**Then** plan name (localized), seats used / total, and next billing date in local format render

### AC-2: Currency from subscription
**Given** plan billing currency is USD
**When** user is on AR locale
**Then** amount displays in USD with localized number formatting (NOT converted)

### AC-3: Role gate
**Given** a non-admin
**When** they navigate to Subscription
**Then** access denied with localized message

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `sales`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] Currency from server, not locale

## Files
- `hogwarts/features/subscription/views/subscription-view.swift`
- `hogwarts/features/subscription/viewmodels/subscription-viewmodel.swift`
- `hogwarts/features/subscription/services/subscription-service.swift`
- `hogwarts/features/subscription/models/subscription.swift`

## API Contract
- `GET /api/mobile/subscription` → `{ plan, currency, seats_used, seats_total, next_billing_at }`

## i18n Keys
- `sales.subscription.plan`, `seats`, `next_billing`, `not_authorized`

## Tests
- `HogwartsTests/subscription/subscription-view-tests.swift`

## Dependencies
- Depends on: AUTH-006, CORE-001
- Blocks: SUB-S-002, SUB-S-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role gate verified
