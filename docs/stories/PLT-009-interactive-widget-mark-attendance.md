# PLT-009: Interactive Widget — Mark Attendance

**Epic**: F-PLATFORM-CORE
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want an interactive widget that lets me mark a student's attendance in one tap from the home screen, so that I can act fast between classes.

## Acceptance Criteria
### AC-1: Widget UI
**Given** the interactive widget is added **When** a class is in session **Then** the widget shows up to 4 students with Present/Absent toggle Buttons (AppIntent-backed).

### AC-2: AppIntent execution
**Given** the teacher taps a button **When** the AppIntent runs **Then** server is called within 5s; widget timeline reloads on success.

### AC-3: Tenant + role guard
**Given** the AppIntent body **When** executing **Then** schoolId from TenantContext is sent; server rejects if mismatched.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId scope (intent payload)
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `HogwartsWidgets/interactive-attendance-widget.swift` — Widget
- `hogwarts/core/intents/mark-attendance-button-intent.swift` — AppIntent
- `hogwarts/features/attendance/services/attendance-service.swift` — call

## API Contract
- `POST /api/mobile/attendance/mark` — `{ schoolId, classId, studentId, status }`

## i18n Keys
- `attendance.widget.markAttendance.title`
- `attendance.widget.markAttendance.present`
- `attendance.widget.markAttendance.absent`
- `attendance.widget.markAttendance.error`

## Tests
- `HogwartsWidgetsTests/interactive-attendance-tests.swift`
- Multi-tenant payload test

## Dependencies
- Depends on: INTENT-004, PLT-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
