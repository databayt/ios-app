# TEST-012: Accessibility Tests (Audit API)

**Epic**: Q-TEST
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** developer
**I want** XCUIApplication.performAccessibilityAudit() runs in CI per critical screen
**So that** accessibility regressions are blocked

## Acceptance Criteria

### AC-1: Audit per critical screen
**Given** the M0 critical screens
**When** audit runs
**Then** zero issues flagged (or issues annotated as known)

### AC-2: CI gate
**Given** new issue introduced
**When** PR runs
**Then** PR blocked with audit report

### AC-3: Localized labels checked
**Given** AR locale
**When** audit runs
**Then** labels exist in AR (not English-only)

## Cross-Cutting Invariants
- [ ] All M0 screens covered
- [ ] AR + EN audited

## Files
- `HogwartsUITests/a11y/a11y-audit-tests.swift`
- `HogwartsUITests/_helpers/audit-config.swift`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- One audit test per critical screen

## Dependencies
- Depends on: TEST-001, A11Y-001
- Blocks: —

## Definition of Done
- [ ] AC met, all M0 screens audited, CI gate active
