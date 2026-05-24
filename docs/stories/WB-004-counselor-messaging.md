# WB-004: Counselor Messaging

**Epic**: WELLBEING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** a private thread with the school counselor
**So that** I can discuss sensitive matters privately

## Acceptance Criteria

### AC-1: Open private thread
**Given** the user has a counselor assigned
**When** they tap "Counselor"
**Then** a separate thread opens flagged `privacy: counselor`

### AC-2: Privacy flag enforced
**Given** a counselor message
**When** any list view renders
**Then** counselor threads do NOT appear in regular MESSAGING lists

### AC-3: No message preview in notifications
**Given** a counselor message arrives
**When** push lands
**Then** body shows generic localized "New counselor message" with no content preview

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: student/guardian
- [ ] Audit log per send
- [ ] Sensitive: no preview in notification

## Files
- `hogwarts/features/wellbeing/views/counselor-thread-view.swift`
- `hogwarts/features/wellbeing/viewmodels/counselor-thread-viewmodel.swift`
- `hogwarts/features/wellbeing/services/counselor-service.swift`

## API Contract
- `GET /api/mobile/wellbeing/counselor/thread` → `{ messages: [] }`
- `POST /api/mobile/wellbeing/counselor/messages` — `{ text }`

## i18n Keys
- `profile.counselor.title`, `placeholder`, `notification_generic`

## Tests
- `HogwartsTests/wellbeing/counselor-messaging-tests.swift`
- Privacy flag isolation test

## Dependencies
- Depends on: MSG infra, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, privacy flag verified, no preview in push
