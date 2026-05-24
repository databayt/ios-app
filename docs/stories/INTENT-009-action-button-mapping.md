# INTENT-009: Action Button Mapping (iPhone 15+)

**Epic**: F-INTENTS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: XS
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to map the iPhone 15+ Action Button to "Mark Attendance", so that I launch attendance with one physical press.

## Acceptance Criteria
### AC-1: Action Button discovery
**Given** an iPhone 15+ user opens Settings → Action Button **When** they pick Shortcut **Then** "Mark Attendance" intent appears (donated via App Shortcuts).

### AC-2: Press launches intent
**Given** the button is mapped **When** pressed **Then** the app launches and runs the intent for the teacher's first/most-recent class.

### AC-3: Camera launch on tap
**Given** the intent runs **When** opening **Then** QR scanner opens immediately (no extra navigation).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId scope (current tenant)
- [ ] Role-gated (teacher only)

## Files
- `hogwarts/core/intents/app-shortcuts-provider.swift` — donate
- `hogwarts/core/intents/mark-attendance-intent.swift` — perform
- `hogwarts/features/attendance/views/qr-scan-view.swift` — opens

## API Contract
None — invokes existing attendance flow.

## i18n Keys
- `attendance.intent.actionButton.title`

## Tests
- `HogwartsTests/intents/action-button-tests.swift`

## Dependencies
- Depends on: INTENT-004
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
