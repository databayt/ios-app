# LOC-009: Content-Language Render — Respect entity.lang

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user receiving an announcement in a language different from my app
**I want** the announcement to render in the author's font + direction
**So that** I read content as the author intended without mis-mirrored layout

## Acceptance Criteria

### AC-1: Per-card direction
**Given** an `Announcement.lang == "en"` and app is `ar` **When** the card renders **Then** the announcement body uses `.environment(\.layoutDirection, .leftToRight)` and the appropriate font (`.hwHeadline` not `.hwArabicHeadline`).

### AC-2: Per-bubble in chat
**Given** mixed-language conversation **When** scrolled **Then** each bubble renders in its own direction; chat-level direction does NOT override bubbles.

### AC-3: Helper
**Given** any view rendering author text **When** it imports `ContentLangModifier` **Then** the modifier handles font + direction in one call.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: per-feature for surrounding chrome)
- [ ] schoolId predicate (entity is tenant-scoped)
- [ ] RTL-tested both directions
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/core/format/content-lang.swift` — `ContentLangModifier`
- Affected card views in announcements / messaging / marking

## API Contract
- Consumes `lang` field already present in entity payloads.

## i18n Keys
- None.

## Tests
- `HogwartsTests/locale/content-lang-tests.swift` — mixed-language fixtures, snapshot AR app + EN content (and vice versa)

## Dependencies
- Depends on: LOC-007
- Blocks: LOC-010, LOC-011, every content-rendering feature

## Definition of Done
- [ ] AC met, snapshot mixed-language scenario, helper used in announcement + message + assignment cards
