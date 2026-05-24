# SUB-S-005: Apple IAP Integration (StoreKit 2)

**Epic**: SUBSCRIPTION-SAAS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L (8)
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As a** school admin
**I want** to upgrade via Apple In-App Purchase
**So that** I can pay through my Apple ID

## Acceptance Criteria

### AC-1: Purchase via StoreKit 2
**Given** admin selects an IAP-eligible plan
**When** they tap "Subscribe via Apple"
**Then** StoreKit 2 sheet appears, transaction completes, receipt is forwarded to backend

### AC-2: Server verifies and updates
**Given** the receipt is sent server-side
**When** Apple verification succeeds
**Then** subscription record updates to new plan; admin sees new plan in view

### AC-3: Restore purchases
**Given** admin reinstalls the app
**When** they tap "Restore Purchases"
**Then** active StoreKit 2 entitlements re-link to backend subscription

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `sales`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: admin only
- [ ] Audit log on purchase/restore
- [ ] StoreKit 2 (no StoreKit 1 fallback)
- [ ] Apple guidelines: clear pricing, restore button visible

## Files
- `hogwarts/features/subscription/services/storekit-manager.swift`
- `hogwarts/features/subscription/views/iap-paywall-view.swift`
- `hogwarts/features/subscription/viewmodels/iap-viewmodel.swift`

## API Contract
- `POST /api/mobile/subscription/iap/verify` — `{ receipt, transaction_id }` → `{ subscription }`
- `POST /api/mobile/subscription/iap/restore` — `{ receipt }`

## i18n Keys
- `sales.subscription.iap_subscribe`, `restore_purchases`, `iap_failed`

## Tests
- `HogwartsTests/subscription/iap-tests.swift`
- StoreKit 2 test session

## Dependencies
- Depends on: SUB-S-002
- Blocks: —

## Definition of Done
- [ ] AC met, StoreKit 2 sandbox test pass, RTL screenshot, restore verified, audit logged
