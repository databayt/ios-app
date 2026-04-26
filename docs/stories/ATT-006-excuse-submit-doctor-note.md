# ATT-006: Excuse Submit (with Doctor's Note)

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
As a guardian, I want to submit an excuse with an optional doctor's-note photo, so that absences are properly documented.

## Acceptance Criteria
### AC-1: Form + photo upload
**Given** I tap "Submit Excuse" **When** the form opens **Then** I can pick child, date(s), reason, and attach a photo (camera or library); submit creates a pending excuse.

### AC-2: Offline queue
**Given** I am offline **When** I submit **Then** the excuse queues; on reconnect, it uploads with photo.

### AC-3: Cross-cutting
Reason localized. RTL form. Photo storage tenant-scoped. EXIF stripped. Audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (guardian only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/excuse-submit-view.swift`
- `hogwarts/features/attendance/viewmodels/excuse-submit-viewmodel.swift`
- `hogwarts/features/attendance/services/excuse-service.swift`

## API Contract
- `POST /api/mobile/attendance/excuses` (multipart) → `{ id, status: "pending" }`

## i18n Keys
- `attendance.excuse.title`, `attendance.excuse.child`, `attendance.excuse.date`, `attendance.excuse.reason`, `attendance.excuse.attach_note`, `attendance.excuse.submitted`

## Tests
- `HogwartsTests/attendance/excuse-submit-tests.swift`
- Offline queue test; multi-tenant isolation

## Dependencies
- Depends on: AUTH-006
- Blocks: ATT-T-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
