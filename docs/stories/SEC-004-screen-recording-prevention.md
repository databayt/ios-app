# SEC-004: Screen Recording / Screenshot Prevention on Sensitive Screens

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** sensitive screens (health, exam) to mask under screenshot/recording
**So that** PII does not leak through device captures

## Acceptance Criteria

### AC-1: Mask on capture
**Given** `UIScreen.main.isCaptured` becomes true
**When** WB-001 (health) or EXAM is visible
**Then** content blurs, tagged sensitive

### AC-2: Screenshot warning
**Given** a screenshot is taken
**When** captured-notification fires
**Then** localized banner appears on the screen

### AC-3: No video preview in app switcher
**Given** the app is backgrounded on sensitive screen
**When** user opens the app switcher
**Then** the snapshot shows a privacy overlay

## Cross-Cutting Invariants
- [ ] Localized strings
- [ ] Sensitive flag enforced per screen

## Files
- `hogwarts/core/security/sensitive-screen.swift`
- `hogwarts/features/wellbeing/views/health-record-view.swift`
- `hogwarts/features/exam/views/exam-view.swift`

## API Contract
- (none)

## i18n Keys
- `common.security.screenshot_blocked`

## Tests
- `HogwartsTests/security/sensitive-screen-tests.swift`

## Dependencies
- Depends on: WB-001
- Blocks: —

## Definition of Done
- [ ] AC met, blur verified, app-switcher overlay verified
