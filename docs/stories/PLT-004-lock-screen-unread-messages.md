# PLT-004: Lock Screen Widget — Unread Messages Count

**Epic**: F-PLATFORM-CORE
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want a Lock Screen widget that shows my unread messages count, so that I notice incoming chat without unlocking.

## Acceptance Criteria
### AC-1: Render counter
**Given** the .accessoryCircular widget **When** unread count > 0 **Then** the badge shows the number; tap opens conversation list.

### AC-2: Tenant scope
**Given** timeline reload **When** computing count **Then** only current schoolId's unread messages are counted.

### AC-3: Zero state
**Given** zero unread **When** rendered **Then** an empty/neutral icon appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId scope (count predicate)
- [ ] Role-gated (own messages)

## Files
- `HogwartsWidgets/unread-messages-widget.swift` — Widget
- `HogwartsWidgets/unread-messages-timeline-provider.swift` — provider
- `hogwarts/core/data/widget-data-bridge.swift` — shared cache

## API Contract
None — local cache.

## i18n Keys
- `messaging.widget.unread.title`
- `messaging.widget.unread.zero`

## Tests
- `HogwartsWidgetsTests/unread-messages-widget-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: PLT-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
