# PLT-X-002: Apple Watch — Attendance Check-In

**Epic**: F-PLATFORM-EXTENDED
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to mark class attendance from my Watch, so that I can take roll without reaching for my phone.

## Acceptance Criteria
### AC-1: Class list on Watch
**Given** the teacher opens the Watch app during class hours **When** loaded **Then** assigned classes for current schoolId render with student count.

### AC-2: Bulk check-in
**Given** a class is opened **When** teacher taps "All Present" **Then** WatchConnectivity sends the action to iPhone, server is called, success haptic returns.

### AC-3: Offline queue
**Given** Watch has no iPhone connection **When** an action is taken **Then** it queues locally and syncs once connected.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId scope (payload)
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `HogwartsWatch/views/attendance-watch-view.swift` — UI
- `HogwartsWatch/services/watch-attendance-service.swift` — actions
- `hogwarts/core/connectivity/watch-connectivity-service.swift` — relay

## API Contract
- `POST /api/mobile/attendance/bulk` — `{ schoolId, classId, allPresent: true }`

## i18n Keys
- `attendance.watch.title`
- `attendance.watch.allPresent`
- `attendance.watch.success`
- `attendance.watch.queuedOffline`

## Tests
- `HogwartsWatchTests/attendance-tests.swift`

## Dependencies
- Depends on: PLT-X-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
