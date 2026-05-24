# ATT-T-003: QR Code Scan Attendance

**Epic**: ATTENDANCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
As a teacher, I want to scan student QR codes (printed on ID cards) to mark attendance, so that bulk-marking is fast and accurate.

## Acceptance Criteria
### AC-1: Camera scans QR
**Given** I open QR Scan **When** a student QR enters frame **Then** the app vibrates, shows the name briefly, and marks Present in <2s.

### AC-2: Duplicate guard
**Given** I scan the same QR twice in 60s **When** the second scan resolves **Then** a toast says "Already marked"; no double-write.

### AC-3: Cross-cutting
Localized prompts. RTL camera overlay. Camera permission denied → explainer + Settings link. schoolId enforced (rejects QR from other tenants).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate (tenant validation on QR payload)
- [ ] Role-gated (teacher only)
- [ ] Audit logged

## Files
- `hogwarts/features/attendance/views/qr-scan-view.swift`
- `hogwarts/features/attendance/viewmodels/qr-scan-viewmodel.swift`
- `hogwarts/features/attendance/services/qr-attendance-service.swift`

## API Contract
- `POST /api/mobile/attendance/qr/scan` — body `{ classId, qrPayload }`

## i18n Keys
- `attendance.qr.title`, `attendance.qr.scanned`, `attendance.qr.duplicate`, `attendance.qr.permission_denied`, `attendance.qr.tenant_mismatch`

## Tests
- `HogwartsTests/attendance/qr-scan-tests.swift`
- Tenant-mismatch QR test; permission flow

## Dependencies
- Depends on: ATT-T-002, IDCARD-* (QR generation)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, role-gated, parity preserved
