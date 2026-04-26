# MSG-021: Emoji Picker

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** an emoji picker accessible from the composer and reactions
**So that** I can quickly add emojis without using the system keyboard

## Acceptance Criteria

### AC-1: Picker UI
**Given** the user taps the emoji button **When** the picker opens **Then** emojis appear by category with search; recent and frequently used surface first.

### AC-2: Insert
**Given** an emoji is tapped **When** in composer **Then** it inserts at the cursor; in reactions context, it submits as the chosen reaction.

### AC-3: Skin tones
**Given** an emoji supports skin tone variants **When** long-pressed **Then** variants surface for selection.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested (category bar mirrors)
- [ ] schoolId predicate (n/a for picker, applies on send)
- [ ] Role-gated

## Files
- `hogwarts/features/messaging/views/emoji-picker.swift`

## API Contract
- No backend; uses local emoji catalog

## i18n Keys
- `messaging.emoji.search`, `messaging.emoji.recent`, `messaging.emoji.smileys`, `messaging.emoji.objects`

## Tests
- `HogwartsTests/messaging/emoji-picker-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: MSG-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
