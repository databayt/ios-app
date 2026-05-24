# TRP-001: Child Route View

**Epic**: TRANSPORT
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to see my child's bus route, stops, and ETA
**So that** I know when to be ready

## Acceptance Criteria

### AC-1: Today's route
**Given** the child is assigned a route
**When** guardian opens Transport
**Then** route stops, pickup time, and current ETA render in localized format

### AC-2: No assignment
**Given** child has no transport
**When** screen loads
**Then** localized empty state with "Contact school" CTA

### AC-3: Map labels
**Given** map is shown
**When** rendered
**Then** street labels appear in app language (or roman fallback)

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `transportation`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children)
- [ ] Map labels in app lang

## Files
- `hogwarts/features/transport/views/child-route-view.swift`
- `hogwarts/features/transport/viewmodels/child-route-viewmodel.swift`
- `hogwarts/features/transport/services/transport-service.swift`
- `hogwarts/features/transport/models/route.swift`

## API Contract
- `GET /api/mobile/transport/route/:childId` → `{ stops: [], pickup_at, eta }`

## i18n Keys
- `transportation.route_title`, `pickup`, `eta`, `no_route`

## Tests
- `HogwartsTests/transport/child-route-tests.swift`

## Dependencies
- Depends on: AUTH-006, GUARDIAN-LINK
- Blocks: TRP-002

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, map lang verified
