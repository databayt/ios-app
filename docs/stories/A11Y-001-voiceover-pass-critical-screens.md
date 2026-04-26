# A11Y-001: VoiceOver Pass Per Critical Screen

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: L (8)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** VoiceOver user
**I want** to navigate every critical screen without dead ends
**So that** I can fully use the app

## Acceptance Criteria

### AC-1: Order, traits, labels
**Given** auth, home, dashboard, attendance, grades, messages
**When** swiped through with VoiceOver
**Then** rotor order is logical, traits correct (button/header/image), labels localized

### AC-2: No dead ends
**Given** each screen
**When** focus traverses
**Then** every interactive element is reachable; modals trap focus; dismiss is announced

### AC-3: Localized labels
**Given** AR locale
**When** VoiceOver speaks
**Then** strings come from AR catalog (not English-only)

## Cross-Cutting Invariants
- [ ] Localized strings (namespace varies)
- [ ] RTL-tested
- [ ] schoolId scoped data
- [ ] Hit targets ≥44pt

## Files
- `hogwarts/features/<feature>/views/*.swift` — accessibility modifiers
- `HogwartsUITests/a11y/voiceover-pass-tests.swift`

## API Contract
- (none)

## i18n Keys
- accessibility labels under `a11y.<screen>.<element>` per feature

## Tests
- One VoiceOver test per critical screen

## Dependencies
- Depends on: TEST-012
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, all M0 screens pass, AR + EN verified
