# MSG-002: Chat View (Bubbles, Per-Message Lang, RTL-Aware)

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: L
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** each chat bubble to render in its own language, font, and direction
**So that** mixed-language conversations look correct regardless of my app language

## Acceptance Criteria

### AC-1: Per-bubble lang
**Given** a conversation contains both Arabic and English bubbles **When** the chat opens **Then** each bubble renders with its own font + direction by overriding `\.layoutDirection` per-bubble (chat-level direction does NOT apply to bubbles).

### AC-2: Translate affordance
**Given** a bubble's language differs from the app language **When** rendered **Then** a small "Translate" affordance appears under the bubble.

### AC-3: Sticky composer
**Given** the user scrolls up **When** the composer renders **Then** it stays anchored to the bottom safe area and switches direction with app language only (not per-bubble).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested with mixed-lang conversation
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] EVERY bubble renders with its own lang/font/direction (per-bubble override of `\.layoutDirection`)

## Files
- `hogwarts/features/messaging/views/chat-view.swift`
- `hogwarts/features/messaging/views/message-bubble.swift`
- `hogwarts/features/messaging/viewmodels/chat-viewmodel.swift`

## API Contract
- `GET /api/mobile/conversations/:id/messages` — `{ messages: [{ id, body, body_lang, sender, sent_at }] }`

## i18n Keys
- `messaging.chat.title`, `messaging.chat.translate`, `messaging.chat.composer_placeholder`

## Tests
- `HogwartsTests/messaging/chat-view-tests.swift`
- Mixed-lang bubble snapshot

## Dependencies
- Depends on: MSG-001
- Blocks: MSG-003, MSG-007, MSG-008

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
