# AIDOC-002: Scan Report Card → Upload to Processing Job

**Epic**: AI-DOC
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to scan a paper report card
**So that** the AI extracts grades and creates a digital record

## Acceptance Criteria

### AC-1: Scan + upload
**Given** the user taps "Scan report card"
**When** scan completes
**Then** PDF uploads with `doc_type: 'report_card'` and a job_id returns

### AC-2: Resume on flaky network
**Given** upload fails mid-stream
**When** network restores
**Then** upload resumes from last byte (or retries up to 3 times)

### AC-3: Multi-page support
**Given** report card has 4 pages
**When** scanned
**Then** all pages combine into a single PDF in correct order

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate on upload
- [ ] Role gate: guardian
- [ ] Privacy: images deleted post-upload

## Files
- `hogwarts/features/ai-doc/views/scan-report-card-view.swift`
- `hogwarts/features/ai-doc/services/upload-resumable.swift`
- `hogwarts/features/ai-doc/services/ai-doc-service.swift`

## API Contract
- `POST /api/mobile/ai-doc/jobs` (multipart) — `{ doc_type: 'report_card', file, lang }` → `{ job_id }`

## i18n Keys
- `common.aidoc.scan_report_card`, `upload_failed`, `retry`

## Tests
- `HogwartsTests/ai-doc/scan-report-card-tests.swift`

## Dependencies
- Depends on: AIDOC-001 (scanner reused)
- Blocks: AIDOC-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, retry verified
