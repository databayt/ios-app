# AIDOC-003: Job Status Polling + Completion Notification

**Epic**: AI-DOC
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** to be notified when document processing completes
**So that** I do not have to keep the app open

## Acceptance Criteria

### AC-1: Poll while foregrounded
**Given** a pending job
**When** app is in foreground
**Then** status polls every 5s until terminal (`succeeded`/`failed`)

### AC-2: Push on completion
**Given** server completes the job (background)
**When** push arrives
**Then** localized "Document ready" notification opens to review screen

### AC-3: Failed job
**Given** job status returns `failed`
**When** user taps the row
**Then** localized error + retry CTA appears

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian
- [ ] Audit log on retry

## Files
- `hogwarts/features/ai-doc/viewmodels/jobs-list-viewmodel.swift`
- `hogwarts/features/ai-doc/services/job-poller.swift`
- `hogwarts/core/notifications/notification-router.swift` — deep link

## API Contract
- `GET /api/mobile/ai-doc/jobs/:id` → `{ id, status, result_url? }`

## i18n Keys
- `common.aidoc.job_processing`, `ready`, `failed`, `retry`

## Tests
- `HogwartsTests/ai-doc/job-status-tests.swift`

## Dependencies
- Depends on: AIDOC-001, AIDOC-002, NOTIF
- Blocks: AIDOC-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, push deep link verified
