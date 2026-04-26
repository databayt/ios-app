# LOC-007: Bidi Text Handling — AttributedString Per-Language Runs

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user reading mixed Arabic + English text (e.g., "درجة المادة MATH-101")
**I want** Arabic and Latin runs to display with correct directionality
**So that** course codes, URLs, and numbers don't appear reversed

## Acceptance Criteria

### AC-1: Per-run language tagging
**Given** an `AttributedString` containing mixed scripts **When** rendered **Then** language identifiers are set per-run, producing correct BiDi marks.

### AC-2: Helper API
**Given** a developer needs mixed-script text **When** they call `BidiText.compose(arabic:, latin:)` **Then** an `AttributedString` with proper run boundaries is returned.

### AC-3: Snapshot
**Given** a sample fixture **When** rendered **Then** AR + EN snapshots show course codes upright, dates correctly directional.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: per-feature)
- [ ] RTL-tested

## Files
- `hogwarts/core/format/bidi-text.swift` — `BidiText.compose(_:)` helper

## API Contract
- None.

## i18n Keys
- None (helper).

## Tests
- `HogwartsTests/locale/bidi-text-tests.swift` — snapshot mixed-script string, run inspection

## Dependencies
- Depends on: LOC-001
- Blocks: messaging, marking, results features

## Definition of Done
- [ ] AC met, snapshot fixture verified, run boundaries inspected programmatically
