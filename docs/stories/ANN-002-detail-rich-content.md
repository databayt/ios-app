# ANN-002: Detail view (rich content, per-message lang)

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to read the full announcement with rich content
**So that** I get the complete message exactly as authored

## Acceptance Criteria

### AC-1: Rich render
**Given** I tap a feed row **When** detail loads **Then** title + rich body (markdown/HTML), attachments, author, published date are shown.

### AC-2: Per-message language
**Given** announcement `lang` differs from app language **When** detail renders **Then** body uses `announcement.lang` font + direction; "Translate" affordance appears.

### AC-3: Error path
**Given** network fails **When** detail fetched **Then** localized error + retry button shown.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested per-message
- [ ] schoolId predicate on detail fetch
- [ ] Entity content lang respected
- [ ] Translate affordance when `lang ≠ app lang`

## Files
- `hogwarts/features/announcements/views/announcement-detail-view.swift` — body renderer
- `hogwarts/features/announcements/viewmodels/announcement-detail-viewmodel.swift`
- `hogwarts/features/announcements/services/translate-service.swift` — calls translate endpoint

## API Contract
- `GET /api/mobile/announcements/:id` — `{ id, title, body, lang, attachments, author, published_at }`
- `POST /api/mobile/translate` — `{ entity_type:"announcement", entity_id, target_lang } → { translated_text, cached }`

## i18n Keys
- `messages.detail.translate`
- `messages.detail.author_label`
- `messages.detail.attachments`
- `errors.network.retry`

## Tests
- `HogwartsTests/announcements/detail-viewmodel-tests.swift`
- Snapshot mixed-language (AR body, EN app), AR + EN

## Dependencies
- Depends on: ANN-001
- Blocks: ANN-003, ANN-004, ANN-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, translate path verified
