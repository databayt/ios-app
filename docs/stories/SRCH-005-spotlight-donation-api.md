# SRCH-005: Spotlight Donation API

**Epic**: F-SEARCH
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want frequently used items (my class, last conversation) to be predicted and surfaced by Siri/Spotlight, so that the OS suggests them on lock screen and Search.

## Acceptance Criteria
### AC-1: NSUserActivity donation
**Given** user opens an entity (class, conversation, announcement) **When** detail view appears **Then** a relevant `NSUserActivity` is donated with `isEligibleForPrediction = true`, persistentIdentifier, and tenant-scoped attributeSet.

### AC-2: Recurrence updates score
**Given** user opens the same entity multiple times **When** donations accumulate **Then** Siri increases prediction priority for that activity.

### AC-3: Tenant cleanup
**Given** user logs out or switches school **When** transition happens **Then** `NSUserActivity.deleteAllSavedUserActivities` is called.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (activity payload + cleanup on switch)
- [ ] Role-gated (only entities visible to role)

## Files
- `hogwarts/core/search/activity-donation-service.swift` — donation helpers
- `hogwarts/features/timetable/views/class-detail-view.swift` — donate
- `hogwarts/features/messaging/views/conversation-detail-view.swift` — donate
- `hogwarts/core/auth/tenant-context.swift` — cleanup on switch

## API Contract
None — local OS interaction.

## i18n Keys
- `common.search.suggestion.class`
- `common.search.suggestion.conversation`

## Tests
- `HogwartsTests/search/activity-donation-tests.swift`

## Dependencies
- Depends on: SRCH-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
