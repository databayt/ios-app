# SHIP-008: Marketing Site + App Store Optimization

**Epic**: SHIP
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** marketing owner
**I want** a marketing site and ASO-optimized App Store metadata
**So that** organic discovery drives downloads

## Acceptance Criteria

### AC-1: Marketing site live
**Given** the launch date
**When** site goes live
**Then** EN + AR landing pages with App Store badge, screenshots, FAQ

### AC-2: ASO keywords
**Given** keyword research
**When** App Store Connect metadata is set
**Then** title, subtitle, keywords, description optimized for both locales

### AC-3: Universal links
**Given** universal links configured
**When** users tap links from the site
**Then** flow opens the app (or App Store if not installed)

## Cross-Cutting Invariants
- [ ] AR + EN parity
- [ ] schoolId-aware deep links
- [ ] No PII on landing forms

## Files
- `docs/release/aso-keywords.md`
- (marketing site lives in the marketing repo)

## API Contract
- (App Store Connect)

## i18n Keys
- (marketing copy lives outside the iOS catalog)

## Tests
- Manual: AR + EN listing reviewed; universal link verified

## Dependencies
- Depends on: SHIP-002, SHIP-007
- Blocks: —

## Definition of Done
- [ ] AC met, both locales live, universal link verified
