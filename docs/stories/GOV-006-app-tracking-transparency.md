# GOV-006: App Tracking Transparency (ATT)

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** explicit opt-in if any tracking occurs
**So that** my privacy preferences are respected

## Acceptance Criteria

### AC-1: ATT prompt only when tracking (App Store gate)
**Given** the app uses tracking-eligible identifiers
**When** the relevant feature is first used
**Then** ATT prompt appears with localized usage description — required for App Store guideline 5.1.2 (tracking requires ATT)

### AC-2: Respect denial
**Given** user denies tracking
**When** any tracking-eligible call is made
**Then** identifier is NOT collected; analytics fall back to anonymous

### AC-3: No prompt if no tracking
**Given** the app does not actually track
**When** session starts
**Then** ATT is NOT shown (Apple penalizes prompts without justified use)

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] App Store BLOCKER (5.1.2)
- [ ] `Info.plist` `NSUserTrackingUsageDescription` localized

## Files
- `hogwarts/Info.plist` — usage description (localized)
- `hogwarts/core/privacy/att-manager.swift`
- `hogwarts/features/gov/services/tracking-service.swift`

## API Contract
- (client-side ATT only)

## i18n Keys
- `common.privacy.att_usage_description` (in InfoPlist.strings)

## Tests
- `HogwartsTests/gov/att-tests.swift`

## Dependencies
- Depends on: OBS-002 (analytics taxonomy)
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, App Store guideline 5.1.2 satisfied, localized usage string
