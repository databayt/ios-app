# ID-005: NFC for kiosk attendance

**Epic**: IDCARD
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student, staff]
**Multi-Tenant**: required

## User Story
**As a** student or staff
**I want** to tap my phone to a kiosk reader
**So that** my attendance is recorded instantly

## Acceptance Criteria

### AC-1: NFC tap
**Given** kiosk active **When** I tap iPhone **Then** CoreNFC pushes `<schoolId>:<userId>` payload; kiosk records attendance.

### AC-2: Confirmation
**Given** attendance recorded **When** confirmed by server **Then** haptic + localized "Checked in" toast in app.

### AC-3: Cross-tenant guard
**Given** kiosk schoolId ≠ active schoolId **When** tapped **Then** rejected; localized error shown.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `attendance`)
- [ ] RTL-tested toast
- [ ] schoolId in NFC payload + verified server-side
- [ ] Audit logged

## Files
- `hogwarts/features/idcard/services/nfc-attendance-service.swift` — CoreNFC
- `hogwarts/features/idcard/views/nfc-status-view.swift`

## API Contract
- (kiosk-side; mobile app emits NDEF payload only)

## i18n Keys
- `profile.idcard.nfc.tap_to_check_in`
- `attendance.nfc.checked_in`
- `attendance.nfc.school_mismatch`

## Tests
- `HogwartsTests/idcard/nfc-tests.swift`
- Cross-tenant rejection test

## Dependencies
- Depends on: ID-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, schoolId verified in NFC payload
