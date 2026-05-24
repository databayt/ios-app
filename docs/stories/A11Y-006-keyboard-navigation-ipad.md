# A11Y-006: Keyboard Navigation (iPad)

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** keyboard user on iPad
**I want** to tab through forms and submit with Enter
**So that** I can use the app without touch

## Acceptance Criteria

### AC-1: Tab order logical
**Given** any form
**When** user tabs
**Then** order matches reading order (RTL respected)

### AC-2: Enter submits, Escape dismisses
**Given** a modal or form
**When** user presses Enter/Escape
**Then** primary/dismiss actions fire respectively

### AC-3: Focus ring visible
**Given** focused element
**When** keyboard navigates
**Then** focus ring renders per system style

## Cross-Cutting Invariants
- [ ] RTL tab order verified
- [ ] All M1 forms covered

## Files
- `hogwarts/components/atom/**` — focusable modifiers
- `hogwarts/features/<feature>/views/*.swift` — keyboard shortcuts

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsUITests/a11y/keyboard-nav-tests.swift`

## Dependencies
- Depends on: A11Y-001
- Blocks: —

## Definition of Done
- [ ] AC met, all M1 forms keyboard-navigable, RTL verified
