# A11Y-008: Voice Control Verification

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** Voice Control user
**I want** every interactive element to be addressable by name
**So that** I can drive the app hands-free

## Acceptance Criteria

### AC-1: Show numbers / Show names
**Given** Voice Control is on with "Show numbers"
**When** any screen renders
**Then** every interactive element gets a number label

### AC-2: Localized command names
**Given** AR locale
**When** Voice Control speaks
**Then** element names come from AR catalog

### AC-3: Custom controls
**Given** custom gesture views
**When** addressed
**Then** they expose proper accessibility traits

## Cross-Cutting Invariants
- [ ] Localized strings
- [ ] All atoms expose proper labels

## Files
- `hogwarts/components/atom/**` — labels
- `HogwartsUITests/a11y/voice-control-tests.swift`

## API Contract
- (none)

## i18n Keys
- per-feature `<ns>.action.<id>`

## Tests
- Voice Control sanity test per critical screen

## Dependencies
- Depends on: A11Y-001
- Blocks: —

## Definition of Done
- [ ] AC met, AR + EN command labels verified
