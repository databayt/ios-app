# MSG-006: Send Voice Message

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to record and send voice messages
**So that** I can communicate quickly without typing

## Acceptance Criteria

### AC-1: Press-and-hold record
**Given** the user presses and holds the mic icon **When** the timer starts **Then** a recording indicator with waveform appears; release sends, swipe away cancels.

### AC-2: Playback
**Given** a voice message is in chat **When** the user taps play **Then** the bubble plays inline with progress indicator and duration.

### AC-3: Permission
**Given** microphone permission is denied **When** the user attempts to record **Then** an alert with "Open Settings" appears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`, `common`)
- [ ] RTL-tested (waveform mirror)
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/messaging/views/voice-recorder.swift`
- `hogwarts/features/messaging/views/voice-bubble.swift`
- `hogwarts/features/messaging/services/voice-upload-service.swift`

## API Contract
- `POST /api/mobile/conversations/:id/messages/voice` (multipart audio)

## i18n Keys
- `messaging.voice.record`, `messaging.voice.cancel`, `messaging.voice.permission_denied`

## Tests
- `HogwartsTests/messaging/send-voice-tests.swift`

## Dependencies
- Depends on: MSG-003
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
