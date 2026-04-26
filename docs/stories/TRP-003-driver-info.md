# TRP-003: Driver Info

**Epic**: TRANSPORT
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: XS (2)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to see the driver's name and contact
**So that** I can communicate in case of issues

## Acceptance Criteria

### AC-1: Render driver card
**Given** a driver is assigned
**When** guardian taps driver card
**Then** name in `entity.lang`, photo, contact button render

### AC-2: Tap-to-call
**Given** the contact button
**When** guardian taps it
**Then** `tel:` deep link launches the dialer with driver number

### AC-3: No driver assigned
**Given** the route has no driver
**When** card shown
**Then** localized "No driver assigned" placeholder

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `transportation`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children)
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/features/transport/views/driver-info-view.swift`
- `hogwarts/features/transport/viewmodels/driver-info-viewmodel.swift`
- `hogwarts/features/transport/services/transport-service.swift`

## API Contract
- `GET /api/mobile/transport/driver/:routeId` → `{ name, photo_url, phone, lang }`

## i18n Keys
- `transportation.driver_title`, `call_driver`, `no_driver`

## Tests
- `HogwartsTests/transport/driver-info-tests.swift`

## Dependencies
- Depends on: TRP-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, entity.lang verified
