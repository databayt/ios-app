# PLT-X-001: Apple Watch — Next Class Glance

**Epic**: F-PLATFORM-EXTENDED
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [student, teacher]
**Multi-Tenant**: required

## User Story
As a student/teacher, I want a Watch app that shows my next class, so that I can glance at my wrist without picking up the phone.

## Acceptance Criteria
### AC-1: Watch app target
**Given** the Watch app is installed **When** opened **Then** it shows class title + time (RTL-aware) for current schoolId.

### AC-2: WatchConnectivity sync
**Given** the iPhone updates the timetable **When** WatchConnectivity transfers data **Then** the Watch UI reflects within 1 minute.

### AC-3: Empty state
**Given** no upcoming class today **When** rendered **Then** localized "No more classes" message appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`)
- [ ] RTL-tested (Watch mirror)
- [ ] schoolId scope (transferred payload tagged)
- [ ] Role-gated
- [ ] Watch sync uses WatchConnectivity, tenant-scoped

## Files
- `HogwartsWatch/HogwartsWatchApp.swift` — Watch app entry
- `HogwartsWatch/views/next-class-watch-view.swift` — UI
- `hogwarts/core/connectivity/watch-connectivity-service.swift` — bridge

## API Contract
None — Watch reads via WatchConnectivity.

## i18n Keys
- `home.watch.nextClass.title`
- `home.watch.nextClass.empty`

## Tests
- `HogwartsWatchTests/next-class-tests.swift`
- Multi-tenant payload test

## Dependencies
- Depends on: PLT-001
- Blocks: PLT-X-002, PLT-X-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
