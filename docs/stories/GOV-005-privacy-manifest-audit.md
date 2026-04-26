# GOV-005: Privacy Manifest Audit + Completion

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** the `PrivacyInfo.xcprivacy` manifest to accurately reflect every data collection event
**So that** App Store accepts the binary

## Acceptance Criteria

### AC-1: Audit data collection (App Store gate)
**Given** the app and SDKs are reviewed
**When** every data type collected is enumerated
**Then** manifest declares each per Apple's privacy taxonomy — required for App Store guideline 5.1.1 (privacy manifest accuracy)

### AC-2: Required reason API declarations
**Given** APIs like `UserDefaults`, `fileTimestamp`, `systemBootTime` are used
**When** static analysis runs
**Then** manifest contains required-reason-API entries with valid reasons

### AC-3: Third-party SDK manifests merged
**Given** Sentry, GoogleSignIn, Stripe, etc. are bundled
**When** archive is built
**Then** Apple aggregator merges manifests successfully

## Cross-Cutting Invariants
- [ ] Localized: not applicable (manifest)
- [ ] schoolId: not applicable
- [ ] Role gate: not applicable
- [ ] App Store BLOCKER (5.1.1)

## Files
- `hogwarts/PrivacyInfo.xcprivacy` — manifest
- `hogwarts/scripts/audit-privacy-manifest.sh` — CI gate

## API Contract
- (none — build-time)

## i18n Keys
- (none)

## Tests
- CI script: `scripts/audit-privacy-manifest.sh` runs on every PR

## Dependencies
- Depends on: All SDKs integrated (OBS-001 etc.)
- Blocks: SHIP-003, SHIP-007

## Definition of Done
- [ ] Manifest declares every data collection accurately
- [ ] All required-reason APIs justified
- [ ] App Store guideline 5.1.1 satisfied
- [ ] CI gate green
