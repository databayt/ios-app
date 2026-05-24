# STR-009: Certificate (PDF)

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** a PDF certificate when I complete a course
**So that** I have proof of completion

## Acceptance Criteria

### AC-1: Generate
**Given** progress = 100% **When** I tap "Get certificate" **Then** server renders PDF in `course.lang` with school branding.

### AC-2: Share
**Given** PDF returned **When** displayed **Then** ShareLink presents file.

### AC-3: Cross-cutting
**Given** certificate **When** rendered **Then** uses `course.lang` font + direction; school logo + name from tenant.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested PDF preview
- [ ] schoolId in path
- [ ] Entity content lang in PDF

## Files
- `hogwarts/features/stream/views/certificate-view.swift`
- `hogwarts/features/stream/services/certificate-actions.swift`

## API Contract
- `GET /api/mobile/stream/courses/:id/certificate` — binary PDF (P2 backend)

## i18n Keys
- `common.stream.certificate.title`
- `common.stream.certificate.download`
- `common.stream.certificate.share`

## Tests
- `HogwartsTests/stream/certificate-tests.swift`

## Dependencies
- Depends on: STR-008
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL PDF screenshot, content lang verified
