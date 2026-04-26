# LIB-006: Return reminder

**Epic**: LIBRARY
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a reminder before my book is due
**So that** I don't incur a fine

## Acceptance Criteria

### AC-1: Auto-schedule
**Given** active borrowing **When** loaded **Then** local notification scheduled 1 day before due.

### AC-2: Tap → detail
**Given** notification fires **When** tapped **Then** routes to LIB-004 row (deep link).

### AC-3: Cross-cutting
**Given** locale `ar-SA` **When** notification renders **Then** body localized; date locale-formatted; title in book.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `library`)
- [ ] RTL-tested notification copy
- [ ] schoolId in deep-link payload
- [ ] Entity content lang for book title in body

## Files
- `hogwarts/features/library/services/return-reminder-service.swift` — UNUserNotificationCenter
- `hogwarts/features/library/viewmodels/my-borrowings-viewmodel.swift`

## API Contract
- (no new endpoint; uses LIB-004)

## i18n Keys
- `library.reminder.title`
- `library.reminder.body`
- `library.reminder.tomorrow`

## Tests
- `HogwartsTests/library/return-reminder-tests.swift`
- Local notification scheduling test

## Dependencies
- Depends on: LIB-004
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId in deep link verified
