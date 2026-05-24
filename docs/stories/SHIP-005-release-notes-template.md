# SHIP-005: Release Notes Template (EN/AR)

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (1)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** a release notes template in EN and AR
**So that** every release ships consistent, localized notes

## Acceptance Criteria

### AC-1: Template committed
**Given** a release
**When** maintainers add notes
**Then** template fields (highlights, fixes, known issues) are completed in both languages

### AC-2: Lint string parity
**Given** notes drafted
**When** lint runs
**Then** EN and AR sections must both exist

### AC-3: TestFlight + App Store render
**Given** notes uploaded
**When** TestFlight + App Store render them
**Then** localized strings show correctly

## Cross-Cutting Invariants
- [ ] AR + EN parity enforced
- [ ] App Store BLOCKER (release submission)

## Files
- `docs/release/release-notes-template.md`
- `hogwarts/scripts/lint-release-notes.sh`

## API Contract
- (none)

## i18n Keys
- (release notes are not catalog-managed; they live with the release process)

## Tests
- `HogwartsTests/release/release-notes-template-tests.swift`

## Dependencies
- Depends on: LOC-002
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, template + lint live
