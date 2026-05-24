# AIDOC-001: Scan Permission Slip via VisionKit OCR

**Epic**: AI-DOC
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to scan a paper permission slip with my camera
**So that** the school can process it without me filling out a form

## Acceptance Criteria

### AC-1: Scan flow
**Given** the user taps "Scan permission slip"
**When** VisionKit document scanner opens
**Then** localized labels (Cancel, Done, Scan) appear and a multi-page A4 PDF is produced

### AC-2: Upload and tag
**Given** scan completes
**When** upload begins
**Then** PDF tagged `school_id`, `entity.lang` (detected) is POSTed and image temp files deleted

### AC-3: Camera denied
**Given** camera permission is denied
**When** the user taps Scan
**Then** localized rationale + Settings deep link

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate on upload
- [ ] Role gate: guardian
- [ ] Privacy: scanned images deleted post-upload

## Files
- `hogwarts/features/ai-doc/views/scan-permission-slip-view.swift`
- `hogwarts/features/ai-doc/services/visionkit-scanner.swift`
- `hogwarts/features/ai-doc/services/ai-doc-service.swift`

## API Contract
- `POST /api/mobile/ai-doc/jobs` (multipart) — `{ doc_type: 'permission_slip', file, lang }` → `{ job_id }`

## i18n Keys
- `common.aidoc.scan_title`, `cancel`, `done`, `camera_denied`, `upload_progress`

## Tests
- `HogwartsTests/ai-doc/scan-permission-slip-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: AIDOC-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, image cleanup verified
