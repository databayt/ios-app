# SHR-005: Handoff Between iPhone and iPad

**Epic**: F-SHARING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want to start composing a message or assignment draft on iPhone and continue on iPad via Handoff, so that drafts follow me across devices.

## Acceptance Criteria
### AC-1: Activity advertised
**Given** user is composing a message draft on iPhone **When** the screen is active **Then** an `NSUserActivity` with `isEligibleForHandoff = true` is advertised, carrying entityType, entityId, schoolId, role.

### AC-2: Continuation on iPad
**Given** the Handoff icon appears on iPad lock screen / app switcher **When** user taps it **Then** the iPad app opens the same composer with the same draft.

### AC-3: Tenant + role guard
**Given** the receiving device is signed in to a different school **When** Handoff continuation arrives **Then** an alert appears, prompting sign-in or skip.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (activity payload)
- [ ] Role-gated (activities tagged with role)

## Files
- `hogwarts/core/sharing/handoff-activity-builder.swift` — activity factories
- `hogwarts/features/messaging/views/message-composer-view.swift` — advertise
- `hogwarts/features/assignments/views/assignment-submit-view.swift` — advertise
- `hogwarts/app/hogwarts-app.swift` — onContinueUserActivity

## API Contract
None — Handoff via NSUserActivity.

## i18n Keys
- `errors.handoff.tenantMismatch`
- `errors.handoff.signInToContinue`

## Tests
- `HogwartsTests/sharing/handoff-tests.swift`
- Multi-tenant continuation test

## Dependencies
- Depends on: SHR-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
