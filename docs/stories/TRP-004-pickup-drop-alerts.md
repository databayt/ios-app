# TRP-004: Pickup/Drop Alerts

**Epic**: TRANSPORT
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** push alerts when the bus is near pickup and at drop
**So that** I do not need to watch the map

## Acceptance Criteria

### AC-1: Geofence near-pickup
**Given** the bus enters the configured geofence radius around the home stop
**When** server triggers
**Then** localized "Bus arriving" push lands

### AC-2: Drop confirmation
**Given** the child is dropped at school/home
**When** server signals drop
**Then** localized "Dropped at <stop>" push lands; `entity.lang` for stop name

### AC-3: Alerts toggleable
**Given** guardian wants to mute alerts
**When** they toggle off in Settings
**Then** server records preference; no further pushes for those events

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `transportation`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children)
- [ ] Audit log on toggle

## Files
- `hogwarts/features/transport/views/transport-settings-view.swift`
- `hogwarts/features/transport/viewmodels/transport-settings-viewmodel.swift`
- `hogwarts/core/notifications/notification-router.swift` — deep link

## API Contract
- `GET /api/mobile/transport/preferences` → `{ pickup_alert, drop_alert }`
- `POST /api/mobile/transport/preferences` — `{ pickup_alert, drop_alert }`

## i18n Keys
- `transportation.pickup_alert`, `drop_alert`, `alerts_off`, `bus_arriving`, `dropped_at`

## Tests
- `HogwartsTests/transport/pickup-drop-alerts-tests.swift`

## Dependencies
- Depends on: TRP-001, NOTIF
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, push deep link verified
