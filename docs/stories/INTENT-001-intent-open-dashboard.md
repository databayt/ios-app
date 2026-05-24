# INTENT-001: Open Dashboard Intent

**Epic**: F-INTENTS
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Siri/Shortcuts intent to open my dashboard, so that "Hey Siri, open Hogwarts dashboard" lands on the role-correct home.

## Acceptance Criteria
### AC-1: Intent registered
**Given** the app is installed **When** user runs the shortcut "Open Dashboard" **Then** the app launches and routes to the role-aware dashboard for current TenantContext.

### AC-2: Voice phrase
**Given** Siri is invoked **When** user says the localized phrase ("Open Hogwarts dashboard" / "افتح لوحة هوغوارتس") **Then** the intent runs.

### AC-3: Not signed in
**Given** there is no active session **When** intent runs **Then** app opens to login screen with a deferred-intent message.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `common`)
- [ ] RTL-tested
- [ ] schoolId scope (current TenantContext)
- [ ] Role-gated (route resolves per role)

## Files
- `hogwarts/core/intents/open-dashboard-intent.swift` — AppIntent
- `hogwarts/core/intents/app-shortcuts-provider.swift` — register
- `hogwarts/app/hogwarts-app.swift` — handle on open

## API Contract
None — local routing.

## i18n Keys
- `home.intent.openDashboard.title`
- `home.intent.openDashboard.phrase`

## Tests
- `HogwartsTests/intents/open-dashboard-intent-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: INTENT-010

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
