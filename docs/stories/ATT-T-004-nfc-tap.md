# ATT-T-004: NFC Tap Attendance

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want students to tap their NFC ID cards to my iPhone to mark Present, so that taking attendance is one-touch fast.

## Acceptance Criteria
### AC-1: Read NFC tag
**Given** I open NFC Mode **When** a student taps their card **Then** the device reads the tag and marks Present with a haptic confirmation.

### AC-2: Tag mismatch
**Given** a tag from another school **When** read **Then** the app rejects with "Tag not from this school".

### AC-3: Cross-cutting
Localized prompts. RTL UI. iOS NFC entitlement required. schoolId validation on tag payload. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/nfc-tap-view.swift`
- `hogwarts/features/attendance/services/nfc-attendance-service.swift`

## API Contract
- `POST /api/mobile/attendance/nfc/tap` — body `{ classId, tagPayload }`

## i18n Keys
- `attendance.nfc.title`, `attendance.nfc.tap_to_mark`, `attendance.nfc.tag_mismatch`, `attendance.nfc.unsupported`

## Tests
- `HogwartsTests/attendance/nfc-tap-tests.swift`
- Tenant-mismatch tag test

## Dependencies
- Depends on: ATT-T-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
