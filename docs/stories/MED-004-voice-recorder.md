# MED-004: Voice Message Recorder (AVAudioRecorder)

**Epic**: F-MEDIA
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to record voice messages up to 60s with waveform feedback
**So that** I can send audio in chat or assignment submissions

## Acceptance Criteria

### AC-1: Hold-to-record
**Given** a chat composer **When** I press and hold the mic button **Then** recording starts with live waveform visualization; release sends.

### AC-2: 60s cap
**Given** I hold past 60s **When** observed **Then** recording auto-stops, an audible cue plays, and the captured clip is offered.

### AC-3: Cancel by slide
**Given** I slide away from the mic while holding **When** released **Then** the recording is discarded.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `messaging`)
- [ ] schoolId predicate (recording tagged before upload)
- [ ] RTL-tested (slide direction in RTL)
- [ ] Microphone rationale localized

## Files
- `hogwarts/core/media/voice-recorder.swift`
- `hogwarts/atoms/hw-voice-record-button.swift`
- `hogwarts/Info.plist` — `NSMicrophoneUsageDescription`

## API Contract
- None (output consumed by feature uploads).

## i18n Keys
- `common.media.permission.microphone.rationale`, `messaging.voice.hold_to_record`, `messaging.voice.slide_to_cancel`

## Tests
- `HogwartsTests/core/media/voice-recorder-tests.swift` — duration cap, cancel path, file output

## Dependencies
- Depends on: MED-001 (permission priming pattern)
- Blocks: messaging voice messages

## Definition of Done
- [ ] AC met, RTL slide-to-cancel verified, real-device 60s cap verified, AR + EN snapshots
