# ANN-003: Read receipts

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** read state tracked per announcement
**So that** I and authors can see what's been read

## Acceptance Criteria

### AC-1: Auto-mark on view
**Given** I open a detail **When** view appears for ≥2s **Then** server is informed; row in feed is no longer bold.

### AC-2: Optimistic + retry
**Given** offline **When** viewing **Then** read marked locally; queued and retried on reconnect.

### AC-3: Cross-cutting
**Given** mark-read mutation **When** sent **Then** it logs `audit { action:"announcement.read" }` with `school_id`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL unaffected (state only)
- [ ] schoolId on mutation
- [ ] Audit logged

## Files
- `hogwarts/features/announcements/services/announcement-actions.swift` — `markRead(id)`
- `hogwarts/features/announcements/viewmodels/announcement-detail-viewmodel.swift` — trigger on appear

## API Contract
- `POST /api/mobile/announcements/:id/read` — `{} → { id, read_at }`

## i18n Keys
- `messages.row.unread_badge`

## Tests
- `HogwartsTests/announcements/read-receipts-tests.swift`
- Offline-queue test

## Dependencies
- Depends on: ANN-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, audit row exists, schoolId scope verified
