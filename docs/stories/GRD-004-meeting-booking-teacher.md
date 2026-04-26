# GRD-004: Meeting booking with teacher

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to book a meeting with my child's teacher
**So that** I can discuss progress

## Acceptance Criteria

### AC-1: Pick teacher + slot
**Given** child profile **When** I tap "Book meeting" **Then** teacher list + available slots shown; I pick one.

### AC-2: Confirm
**Given** I confirm **When** booked **Then** server records meeting; both parties notified.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** `school_id` + `child_id` enforced; audit `{ action:"meeting.book" }`; date in school timezone.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested calendar grid
- [ ] schoolId on POST
- [ ] Audit logged
- [ ] Role gate (guardian only)
- [ ] School timezone for slots

## Files
- `hogwarts/features/guardian/views/meeting-booking-view.swift`
- `hogwarts/features/guardian/viewmodels/meeting-booking-viewmodel.swift`
- `hogwarts/features/guardian/services/guardian-actions.swift` — `bookMeeting`

## API Contract
- `GET /api/mobile/guardian/teachers/:teacherId/availability` — `[ { slot_id, starts_at } ]` (P2 backend)
- `POST /api/mobile/guardian/meetings` — `{ teacher_id, child_id, slot_id } → { id }`

## i18n Keys
- `profile.meeting.book`
- `profile.meeting.pick_teacher`
- `profile.meeting.pick_slot`
- `profile.meeting.confirm`

## Tests
- `HogwartsTests/guardian/meeting-booking-tests.swift`

## Dependencies
- Depends on: GRD-002, GRD-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
