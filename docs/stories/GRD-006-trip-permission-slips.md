# GRD-006: Trip permission slips

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to sign trip permission slips for my child
**So that** they can attend school trips

## Acceptance Criteria

### AC-1: List
**Given** pending trip slips **When** I open Trip Slips **Then** rows show trip title, date, fee, deadline.

### AC-2: Sign + pay if needed
**Given** slip with fee **When** I sign **Then** routed to PAY-001/002 if unpaid; signed only after payment confirmed.

### AC-3: Cross-cutting
**Given** signed **When** stored **Then** PDF + signature retained per `<schoolId>:<childId>:<tripId>`; audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId + childId on POST
- [ ] Audit logged
- [ ] Role gate (guardian only)
- [ ] Currency from TenantContext (when fee shown)
- [ ] Entity content lang for trip body

## Files
- `hogwarts/features/guardian/views/trip-slip-list-view.swift`
- `hogwarts/features/guardian/views/trip-slip-detail-view.swift`
- `hogwarts/features/guardian/services/guardian-actions.swift` — `signTrip`

## API Contract
- `GET /api/mobile/guardian/trip-slips` — `[ { id, child_id, trip:{title,body,lang,starts_at,fee,currency}, deadline } ]` (P2 backend)
- `POST /api/mobile/guardian/trip-slips/:id/sign` — `{ payment_receipt_id? } → { signed_at }`

## i18n Keys
- `profile.trip.title`
- `profile.trip.fee`
- `profile.trip.deadline`
- `profile.trip.sign`

## Tests
- `HogwartsTests/guardian/trip-slip-tests.swift`

## Dependencies
- Depends on: GRD-005, PAY-001, PAY-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
