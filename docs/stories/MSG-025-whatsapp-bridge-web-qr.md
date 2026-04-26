# MSG-025: WhatsApp Bridge (Web QR Pairing)

**Epic**: MESSAGING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user (often guardians)
**I want** to pair my WhatsApp account via web QR
**So that** I can receive school messages in WhatsApp alongside the app

## Acceptance Criteria

### AC-1: QR pairing
**Given** the user opens WhatsApp Bridge in settings **When** they tap "Pair WhatsApp" **Then** a QR is fetched from the bridge service and rendered for the user to scan via WhatsApp Web.

### AC-2: Status updates
**Given** pairing is in progress **When** the bridge responds **Then** the UI reflects states: Pending, Connected, Failed; on success the user's WA contact id stores server-side.

### AC-3: Unpair
**Given** the bridge is connected **When** the user taps Unpair **Then** the link is severed server-side and confirmed in UI.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `whatsapp`, `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate (bridge entry per school)
- [ ] Role-gated
- [ ] Audit logged on pair/unpair

## Files
- `hogwarts/features/messaging/views/whatsapp-bridge-view.swift`
- `hogwarts/features/messaging/services/whatsapp-bridge-service.swift`

## API Contract
- `POST /api/mobile/whatsapp/bridge/pair` — returns `{ qr_token, qr_image_url }`
- `GET /api/mobile/whatsapp/bridge/status` — returns `{ status }`
- `POST /api/mobile/whatsapp/bridge/unpair`

## i18n Keys
- `whatsapp.bridge.title`, `whatsapp.bridge.scan_qr`, `whatsapp.bridge.connected`, `whatsapp.bridge.failed`, `whatsapp.bridge.unpair`

## Tests
- `HogwartsTests/messaging/whatsapp-bridge-tests.swift`

## Dependencies
- Depends on: MSG-002, CORE-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
