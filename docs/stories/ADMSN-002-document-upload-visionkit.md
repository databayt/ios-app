# ADMSN-002: Document Upload (with VisionKit)

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent
**I want** to scan or upload required admission documents
**So that** I do not need a printer/scanner

## Acceptance Criteria

### AC-1: Scan via VisionKit
**Given** the user taps "Scan birth certificate"
**When** scanner opens
**Then** A4-cropped B&W PDF is produced and uploaded with `school_id`

### AC-2: Pick from Files
**Given** the user taps "Pick from Files"
**When** Files importer opens
**Then** PDF/image is uploaded with same envelope

### AC-3: Required documents checklist
**Given** the documents tab loads
**When** uploads complete
**Then** checklist updates with green check per required doc

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate on upload
- [ ] Role gate: public
- [ ] Privacy: scanned images deleted after upload

## Files
- `hogwarts/features/admission/views/document-upload-view.swift`
- `hogwarts/features/admission/services/document-upload-service.swift`
- `hogwarts/features/ai-doc/services/visionkit-scanner.swift` — reused

## API Contract
- `POST /api/mobile/admission/applications/:id/documents` (multipart) — `{ type, file }` → `{ document_id }`

## i18n Keys
- `common.admission.scan_document`, `pick_from_files`, `documents_required`, `birth_certificate`

## Tests
- `HogwartsTests/admission/document-upload-tests.swift`

## Dependencies
- Depends on: ADMSN-001, AIDOC-001 (scanner reused)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, image cleanup verified, A4 crop verified
