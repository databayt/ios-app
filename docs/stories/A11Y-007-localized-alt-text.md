# A11Y-007: Localized Alt Text on Every Image

**Epic**: Q-A11Y
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** VoiceOver user on AR or EN
**I want** every image to have a localized alt text
**So that** I understand visual content

## Acceptance Criteria

### AC-1: Every image has label
**Given** any decorative image
**When** rendered
**Then** has `accessibilityHidden(true)` OR localized label

### AC-2: AR + EN both
**Given** images with labels
**When** AR locale
**Then** label resolves from AR catalog (not English fallback)

### AC-3: Lint
**Given** CI
**When** code is changed
**Then** lint blocks new `Image(...)` without `accessibilityLabel` or `accessibilityHidden`

## Cross-Cutting Invariants
- [ ] Localized strings (per feature namespace)
- [ ] Lint enforced

## Files
- `hogwarts/scripts/lint-image-a11y.sh` — CI gate
- `hogwarts/components/atom/**` — image atoms updated

## API Contract
- (none)

## i18n Keys
- per-feature `<ns>.image.<id>` keys

## Tests
- `HogwartsTests/a11y/image-alt-tests.swift`

## Dependencies
- Depends on: A11Y-001
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, lint active, all images covered AR + EN
