# TRP-002: Live Bus Tracking

**Epic**: TRANSPORT
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L (8)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to see the bus position in real time
**So that** I can plan when to walk to the stop

## Acceptance Criteria

### AC-1: Live position with 30s freshness
**Given** the bus is en route
**When** guardian opens tracking
**Then** map shows bus position with timestamp, refreshing at most every 30s

### AC-2: WebSocket only when active
**Given** the screen is backgrounded
**When** app pauses
**Then** WebSocket disconnects to preserve battery; reconnects on foreground

### AC-3: Trip ended
**Given** the trip terminates
**When** server signals end
**Then** map shows final position with localized "Trip complete" banner

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `transportation`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children)
- [ ] Battery: socket only when foregrounded

## Files
- `hogwarts/features/transport/views/live-tracking-view.swift`
- `hogwarts/features/transport/viewmodels/live-tracking-viewmodel.swift`
- `hogwarts/features/transport/services/tracking-socket.swift`

## API Contract
- WebSocket `/api/mobile/transport/ws/route/:routeId` — server pushes `{ lat, lng, updated_at }`
- `GET /api/mobile/transport/route/:routeId/position` (fallback)

## i18n Keys
- `transportation.live_title`, `last_update`, `trip_complete`, `reconnecting`

## Tests
- `HogwartsTests/transport/live-tracking-tests.swift`
- Battery suspend/resume test

## Dependencies
- Depends on: TRP-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, battery behavior verified, freshness 30s
