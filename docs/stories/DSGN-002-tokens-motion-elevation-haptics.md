# DSGN-002: Token Completion — Motion, Elevation, Haptics, Gradients

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** developer
**I want** named motion curves, elevation shadows, haptic patterns, and gradient tokens
**So that** every animation/shadow/feedback is consistent and Reduce-Motion-aware

## Acceptance Criteria

### AC-1: Motion tokens
**Given** an atom needs animation **When** it imports `AppleAnimation` **Then** `.smooth`, `.snap`, `.bounce`, `.glass` tokens are available with documented durations.

### AC-2: Elevation tokens
**Given** an atom uses elevation **When** declared **Then** `Elevation.low/.medium/.high/.modal` tokens map to `shadow()` modifiers.

### AC-3: Haptics tokens
**Given** a user action **When** triggered **Then** `Haptics.success/.warning/.tap/.selection/.heavy` plays via `UIImpactFeedbackGenerator` (no-op if Reduce-Motion).

### AC-4: Gradient tokens
**Given** Liquid Glass surfaces **When** rendered **Then** `Gradients.glassFrosted/.glassClear/.brand` semantic tokens drive the look.

## Cross-Cutting Invariants
- [ ] Reduce-Motion respected (motion tokens collapse to instant)

## Files
- `hogwarts/design/tokens/motion.swift`
- `hogwarts/design/tokens/elevation.swift`
- `hogwarts/design/tokens/haptics.swift`
- `hogwarts/design/tokens/gradients.swift`

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/design/token-tests.swift` — Reduce-Motion path, haptic generator hooks

## Dependencies
- Depends on: none
- Blocks: DSGN-001, DSGN-005

## Definition of Done
- [ ] AC met, every existing atom adopts at least one new token, Reduce-Motion verified
