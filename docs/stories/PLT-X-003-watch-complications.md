# PLT-X-003: Apple Watch Complications

**Epic**: F-PLATFORM-EXTENDED
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want Watch face complications for next class and unread messages, so that I see them on every glance.

## Acceptance Criteria
### AC-1: Complications bundled
**Given** the Watch app is installed **When** the user adds a complication **Then** "Next Class" and "Unread Messages" are selectable in the watch face customizer.

### AC-2: Tap-to-open
**Given** a complication is tapped **When** activated **Then** the Watch app opens to the matching screen (timetable for next class; conversation list for unread).

### AC-3: RTL strings
**Given** Arabic locale **When** complication renders **Then** Arabic abbreviations are used (no truncation).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `messaging`)
- [ ] RTL-tested
- [ ] schoolId scope (provider reads tenant)
- [ ] Role-gated

## Files
- `HogwartsWatchWidgets/next-class-complication.swift` — Widget
- `HogwartsWatchWidgets/unread-messages-complication.swift` — Widget
- `HogwartsWatchWidgets/timeline-providers.swift` — providers

## API Contract
None — same shared cache as PLT-X-001.

## i18n Keys
- `home.watch.complication.nextClass`
- `messaging.watch.complication.unread`

## Tests
- `HogwartsWatchWidgetsTests/complications-tests.swift`

## Dependencies
- Depends on: PLT-X-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
