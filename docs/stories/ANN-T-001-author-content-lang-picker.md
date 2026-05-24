# ANN-T-001: Author announcement (with content language picker)

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher]
**Multi-Tenant**: required

## User Story
**As an** admin or teacher
**I want** to compose an announcement and pick its content language
**So that** the message renders with correct font/direction for all readers

## Acceptance Criteria

### AC-1: Compose + pick lang
**Given** I tap "New announcement" **When** I enter title + body and pick `lang` (default = app language) **Then** server stores `{ title, body, lang, school_id, author_id }`.

### AC-2: Validation
**Given** missing title **When** I tap publish **Then** localized validation error appears.

### AC-3: Role gate
**Given** student/guardian role **When** they open feed **Then** "New announcement" entry point is hidden.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested composer (lang-aware preview)
- [ ] schoolId on POST
- [ ] Role gate (admin, teacher)
- [ ] Audit logged on publish
- [ ] Stored `lang` separate from author's UI language

## Files
- `hogwarts/features/announcements/views/author-announcement-view.swift` — composer + lang picker
- `hogwarts/features/announcements/viewmodels/author-viewmodel.swift`
- `hogwarts/features/announcements/services/announcement-actions.swift` — `publish(...)`

## API Contract
- `POST /api/mobile/announcements` — `{ title, body, lang, attachments[] } → { id, published_at }`

## i18n Keys
- `messages.author.new`
- `messages.author.title_label`
- `messages.author.body_label`
- `messages.author.lang_label`
- `messages.author.publish`

## Tests
- `HogwartsTests/announcements/author-tests.swift`
- Multi-tenant isolation test, role-gate test

## Dependencies
- Depends on: AUTH-006, ANN-001
- Blocks: ANN-T-002, ANN-T-003, ANN-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists, role gate verified
