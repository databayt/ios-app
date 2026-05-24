# ATT-T-006: Kiosk Mode (Single-Class Locked)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [teacher, admin]
**Multi-Tenant**: required

## User Story
As a teacher (or admin), I want a kiosk mode that locks the device to a single class roster for self-check-in, so that students can mark themselves Present at a shared device.

## Acceptance Criteria
### AC-1: Enter Single App Mode
**Given** I select "Start Kiosk" with a class **When** I confirm with PIN **Then** the device enters Single App Mode (Guided Access prompt) and shows the class roster as a touch-list.

### AC-2: Self check-in tap
**Given** a student taps their name **When** the row registers **Then** Present is recorded; row strikes through with timestamp.

### AC-3: Exit requires PIN
**Given** I tap Exit **When** the PIN dialog appears **Then** correct PIN exits Kiosk; wrong PIN keeps it locked.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (teacher, admin)
- [ ] Audit logged (entry/exit, marks)

## Files
- `hogwarts/features/attendance/views/kiosk-mode-view.swift`
- `hogwarts/features/attendance/viewmodels/kiosk-viewmodel.swift`
- `hogwarts/features/attendance/services/kiosk-service.swift`

## API Contract
- `POST /api/mobile/attendance/kiosk/start`
- `POST /api/mobile/attendance/kiosk/checkin` — body `{ sessionId, studentId }`
- `POST /api/mobile/attendance/kiosk/end`

## i18n Keys
- `attendance.kiosk.title`, `attendance.kiosk.tap_name`, `attendance.kiosk.checked_in`, `attendance.kiosk.exit_pin`

## Tests
- `HogwartsTests/attendance/kiosk-tests.swift`
- PIN-exit flow

## Dependencies
- Depends on: ATT-T-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
