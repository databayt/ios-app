# EXAM-008: Certificate (PDF, Share)

**Epic**: EXAMS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to download and share a PDF certificate of a passed exam
**So that** I can save it as proof or share with relatives

## Acceptance Criteria

### AC-1: Eligibility
**Given** the student passed the exam **When** they open results **Then** a "Get certificate" button appears; for failed/pending exams it is hidden.

### AC-2: PDF preview
**Given** the user taps Get Certificate **When** the request resolves **Then** the PDF previews in PDFKit with school seal, student name, exam name, score.

### AC-3: Share
**Given** the certificate is shown **When** the user taps Share **Then** the iOS share sheet opens with the PDF.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (cache + filename include school)
- [ ] Role-gated
- [ ] Filename respects `exam.lang`

## Files
- `hogwarts/features/exams/views/certificate-view.swift`
- `hogwarts/features/exams/services/certificate-service.swift`

## API Contract
- `GET /api/mobile/exams/:id/certificate` — returns PDF binary

## i18n Keys
- `results.exam.certificate_cta`, `results.exam.certificate_loading`

## Tests
- `HogwartsTests/exams/certificate-tests.swift`

## Dependencies
- Depends on: EXAM-007, SHR-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
