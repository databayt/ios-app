# SHIP-004: Export Compliance (Encryption Use)

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (1)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** export compliance answered correctly in Info.plist
**So that** App Store distribution is permitted

## Acceptance Criteria

### AC-1: ITSAppUsesNonExemptEncryption set
**Given** the app uses TLS only (exempt usage)
**When** Info.plist is configured
**Then** `ITSAppUsesNonExemptEncryption=NO` (or correct value with documentation)

### AC-2: Annual self-classification
**Given** classification is required
**When** annual filing is due
**Then** the report is filed with the U.S. Bureau of Industry and Security (if applicable)

### AC-3: Documentation
**Given** the team
**When** reviewing
**Then** `docs/release/export-compliance.md` documents the decision

## Cross-Cutting Invariants
- [ ] App Store BLOCKER

## Files
- `hogwarts/Info.plist`
- `docs/release/export-compliance.md`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Manual: Info.plist verified, doc reviewed

## Dependencies
- Depends on: —
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, Info.plist correct, doc committed
