# ID-002: Apple Wallet pass (PassKit)

**Epic**: IDCARD
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** my ID card in Apple Wallet
**So that** I can access it without opening the app

## Acceptance Criteria

### AC-1: Add to Wallet
**Given** ID-001 view **When** I tap "Add to Apple Wallet" **Then** server returns `.pkpass`; PKAddPassesViewController presents.

### AC-2: Update on role change
**Given** my role changes server-side **When** push update arrives **Then** Wallet pass auto-refreshes.

### AC-3: Cross-cutting
**Given** pass renders **When** displayed **Then** uses school logo + theme; QR payload includes `<schoolId>:<userId>`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested CTA
- [ ] schoolId in pass payload
- [ ] School theme + logo
- [ ] Audit logged on add

## Files
- `hogwarts/features/idcard/services/wallet-pass-service.swift` — PassKit
- `hogwarts/features/idcard/views/idcard-view.swift` — button

## API Contract
- `GET /api/mobile/idcard/wallet-pass` — `application/vnd.apple.pkpass` (P2 backend)
- (server uses APNs to push pass updates per Apple Wallet protocol)

## i18n Keys
- `profile.idcard.add_to_wallet`
- `profile.idcard.wallet_added`

## Tests
- `HogwartsTests/idcard/wallet-pass-tests.swift`
- Pass refresh test

## Dependencies
- Depends on: ID-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, schoolId in pass verified, audit row exists
