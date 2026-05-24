# DASH-G-002: Guardian Quick Actions

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
As a guardian, I want one-tap actions (submit excuse, message teacher) from the dashboard, so that I act fast.

## Acceptance Criteria
### AC-1: Two action chips
**Given** dashboard with selected child **When** quick-actions render **Then** I see "Submit Excuse" and "Message Teacher" chips, each with deep-link.

### AC-2: Action navigates with context
**Given** I tap "Message Teacher" **When** screen opens **Then** the recipient is pre-filled with the homeroom teacher of the selected child.

### AC-3: Cross-cutting
RTL chip order reverses. Localized labels. Audit logs the action invocation.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `attendance`, `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (guardian only)
- [ ] Audit logged (deep-link initiation)

## Files
- `hogwarts/features/dashboard/views/guardian-quick-actions.swift`
- `hogwarts/features/dashboard/viewmodels/guardian-dashboard-viewmodel.swift`

## API Contract
- (uses existing endpoints behind navigation; no new endpoint)

## i18n Keys
- `home.guardian.action.excuse`, `home.guardian.action.message_teacher`

## Tests
- `HogwartsTests/dashboard/guardian-quick-actions-tests.swift`
- Deep-link routing test

## Dependencies
- Depends on: DASH-G-001, ATT-006, MSG-* (messaging)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
