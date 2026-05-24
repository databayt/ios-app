# MSG-020: Link Previews

**Epic**: MESSAGING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** URLs in messages to render with rich previews (title, image, host)
**So that** I can preview links without opening them

## Acceptance Criteria

### AC-1: Preview render
**Given** a message contains a URL **When** rendered **Then** an LPLinkView preview appears below the text with title, image, host.

### AC-2: User opt-in
**Given** the user disabled previews in settings **When** a URL message renders **Then** only the raw URL appears.

### AC-3: Privacy fetch
**Given** server pre-fetched preview data **When** rendered **Then** the client uses server-provided OpenGraph data first to avoid client-side fetches that leak browsing data.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested (preview alignment)
- [ ] schoolId predicate
- [ ] Role-gated

## Files
- `hogwarts/features/messaging/views/link-preview.swift`
- `hogwarts/features/messaging/services/link-preview-service.swift`

## API Contract
- Server attaches `link_preview` to message body when ready: `{ title, image_url, host }`

## i18n Keys
- `messaging.link_preview.disabled`, `messaging.link_preview.loading`

## Tests
- `HogwartsTests/messaging/link-preview-tests.swift`

## Dependencies
- Depends on: MSG-002
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
