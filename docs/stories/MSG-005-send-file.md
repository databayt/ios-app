# MSG-005: Send File

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to send PDFs or other documents in a chat
**So that** I can share materials directly

## Acceptance Criteria

### AC-1: Files picker
**Given** the user taps the File attachment button **When** the iOS Files picker opens **Then** they can select files from any provider.

### AC-2: Bubble preview
**Given** a file is selected **When** uploaded **Then** the message bubble shows file icon, name, size, and download CTA.

### AC-3: Size cap
**Given** a file exceeds the configured server cap **When** the user taps Send **Then** an inline error blocks upload and explains the limit.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `errors`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/services/file-upload-service.swift`
- `hogwarts/features/messaging/views/file-bubble.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/file` (multipart)

## i18n Keys
- `messaging.attach.file`, `messaging.file.too_large`, `messaging.file.uploading`

## Tests
- `HogwartsTests/messaging/send-file-tests.swift`

## Dependencies
- Depends on: MSG-003, INT-004
- Blocks: MSG-022

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
