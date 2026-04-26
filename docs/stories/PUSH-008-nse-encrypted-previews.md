# PUSH-008: NSE for End-to-End-Encrypted Message Previews

**Epic**: F-PUSH
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user receiving an E2EE message
**I want** the notification to decrypt and show a preview of the actual content
**So that** I can read it without opening the app, while keeping content private from the server

## Acceptance Criteria

### AC-1: Server sends ciphertext
**Given** an E2EE message **When** APNs payload arrives **Then** body field is the ciphertext, not plaintext.

### AC-2: NSE decrypts
**Given** the NSE runs **When** processing **Then** it uses Keychain-stored private key to decrypt and replaces `bestAttemptContent.body` with plaintext localized via `notifications.preview.message`.

### AC-3: Decrypt failure fallback
**Given** decryption fails **When** observed **Then** the notification falls back to a generic "New message from <sender>".

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `notifications`)
- [ ] schoolId predicate (key lookup tenant-scoped)
- [ ] No plaintext leaked to logs

## Files
- `HogwartsNotificationService/e2ee-decrypt.swift`
- `HogwartsNotificationService/notification-service.swift` — extend with decrypt path

## API Contract
- Notification payload extension carries `cipher`, `nonce`, `sender_key_id` fields.

## i18n Keys
- `notifications.preview.message`, `notifications.preview.fallback_new_message`

## Tests
- `HogwartsNotificationServiceTests/e2ee-tests.swift` — decrypt happy path, decrypt failure fallback, no log leak

## Dependencies
- Depends on: PUSH-006 — and an E2EE messaging epic (out-of-scope here; story is foundation-ready)
- Blocks: none

## Definition of Done
- [ ] AC met, decrypt fixture works, failure fallback verified, parity preserved
