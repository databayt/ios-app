# SHIP-003: Privacy Manifest Finalization

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** PrivacyInfo.xcprivacy finalized with accurate declarations
**So that** App Review accepts on first submission

## Acceptance Criteria

### AC-1: Final declarations accurate
**Given** GOV-005 audit
**When** binary archive is built
**Then** every collected data type, purpose, linkage, and tracking flag is correct

### AC-2: Cross-checked against App Store privacy answers
**Given** the App Store privacy questionnaire
**When** answers are submitted
**Then** answers match the manifest exactly

### AC-3: Third-party SDK manifests merged
**Given** all SDKs include their own manifests
**When** archive is built
**Then** Apple aggregator merges without conflicts

## Cross-Cutting Invariants
- [ ] App Store BLOCKER (5.1.1)
- [ ] No PII collection without justification

## Files
- `hogwarts/PrivacyInfo.xcprivacy`
- `docs/release/privacy-manifest-final.md`

## API Contract
- (none — build-time)

## i18n Keys
- (none)

## Tests
- CI script `audit-privacy-manifest.sh`

## Dependencies
- Depends on: GOV-005, SHIP-001
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, App Store privacy questionnaire matches manifest
