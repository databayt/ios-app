# ASGN-004: Photo Submission (Camera + Scan)

**Epic**: ASSIGNMENTS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to scan or photograph my handwritten work and submit it
**So that** I can hand in paper-based assignments without leaving the app

## Acceptance Criteria

### AC-1: VisionKit scan
**Given** the user taps Scan & Submit **When** the VNDocumentCameraViewController opens **Then** they can capture multi-page documents with auto-edge detection and flatten.

### AC-2: PDF assembly
**Given** the user scans 3 pages **When** they tap Save **Then** pages assemble into a single PDF and the upload begins via background URLSession.

### AC-3: Permission handling
**Given** camera permission is denied **When** the user taps Scan **Then** an alert with "Open Settings" CTA appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Audit logged

## Files
- `hogwarts/features/assignments/views/photo-submission-view.swift`
- `hogwarts/features/assignments/services/document-scanner-service.swift`

## API Contract
- Reuses `POST /api/mobile/assignments/:id/submissions` (multipart with PDF)

## i18n Keys
- `marking.asgn.scan_submit`, `marking.asgn.camera_denied`, `marking.asgn.add_page`, `marking.asgn.done_scanning`

## Tests
- `HogwartsTests/assignments/photo-submission-tests.swift`

## Dependencies
- Depends on: ASGN-002, INT-005
- Blocks: ASGN-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
