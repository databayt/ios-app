# PLT-X-005: visionOS Support

**Epic**: F-PLATFORM-EXTENDED
**Priority**: P2
**Phase**: M3 (deferred)
**Status**: pending
**Effort**: XL
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a future visionOS user, I want a scaffolded visionOS target, so that the app can ship to Vision Pro when prioritized.

## Acceptance Criteria
### AC-1: Target compiles
**Given** the visionOS target is added **When** built **Then** the app compiles with no major UIKit-only dependencies (uses SwiftUI primitives only).

### AC-2: Window + ornament basics
**Given** the app runs in Vision Pro **When** opened **Then** a primary Window scene renders the dashboard; ornament (toolbar) hosts navigation.

### AC-3: No production polish (deferred)
**Given** this is a scaffold **When** reviewed **Then** acknowledged as "not shipping in M2" — deferred to M3+.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested
- [ ] schoolId scope (per-feature)
- [ ] Role-gated (existing)
- [ ] visionOS scaffolded but not shipped

## Files
- `HogwartsVisionOS/HogwartsVisionApp.swift` — entry
- `HogwartsVisionOS/views/vision-root-view.swift` — primary scene

## API Contract
None.

## i18n Keys
- (uses existing home keys)

## Tests
- `HogwartsVisionOSTests/scaffold-tests.swift`

## Dependencies
- Depends on: PLT-010
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
