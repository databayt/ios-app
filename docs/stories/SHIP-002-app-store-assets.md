# SHIP-002: App Store Assets (Screenshots EN/AR for All Device Sizes)

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: done
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** App Store screenshots in EN and AR for every required device size
**So that** the listing is approved and localized

## Acceptance Criteria

### AC-1: All required sizes
**Given** App Store Connect required sizes (6.7", 6.5", 5.5", iPad Pro 12.9")
**When** assets are uploaded
**Then** every size has 5+ screenshots

### AC-2: AR + EN parity
**Given** EN listing
**When** AR listing renders
**Then** equivalent screenshots exist in Arabic with mirrored RTL UI

### AC-3: App preview video (optional)
**Given** a preview video script
**When** captured
**Then** preview is uploaded for primary size

## Cross-Cutting Invariants
- [ ] Strings in screenshots use real localized copy
- [ ] schoolId-safe (no real customer data)

## Files
- `hogwarts/scripts/capture-screenshots.sh`
- `docs/release/app-store-assets.md`

## API Contract
- (none — App Store Connect)

## i18n Keys
- (none — assets, but copy is localized)

## Tests
- `HogwartsUITests/screenshots/screenshot-capture-tests.swift`

## Dependencies
- Depends on: SHIP-001
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, AR + EN listings ready for submission
