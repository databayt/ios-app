# ADMSN-004: Tour Booking

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent
**I want** to book a school tour slot
**So that** I can visit the school in person

## Acceptance Criteria

### AC-1: View available slots
**Given** the school publishes tour slots
**When** user opens Tour Booking
**Then** slots render with date/time in localized format and capacity remaining

### AC-2: Book slot
**Given** a slot has capacity
**When** user fills name + phone and confirms
**Then** booking confirmation + EventKit "Add to Calendar" CTA appears

### AC-3: Cancel
**Given** an existing booking
**When** user taps "Cancel"
**Then** server releases capacity, booking removed from local store

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: public
- [ ] Audit log on book/cancel

## Files
- `hogwarts/features/admission/views/tour-booking-view.swift`
- `hogwarts/features/admission/viewmodels/tour-booking-viewmodel.swift`
- `hogwarts/features/admission/services/tour-service.swift`

## API Contract
- `GET /api/mobile/admission/tour-slots` → `{ slots: [{ id, start, end, capacity_left }] }`
- `POST /api/mobile/admission/tour-bookings` — `{ slot_id, name, phone }`
- `DELETE /api/mobile/admission/tour-bookings/:id`

## i18n Keys
- `common.admission.tour_title`, `book`, `cancel`, `add_to_calendar`, `confirm`

## Tests
- `HogwartsTests/admission/tour-booking-tests.swift`

## Dependencies
- Depends on: ADMSN-001, INT-001 (EventKit)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, calendar integration verified
