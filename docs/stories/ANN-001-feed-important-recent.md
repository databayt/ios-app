# ANN-001: Feed (Important + Recent sections)

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user (any role)
**I want** an announcement feed with Important and Recent sections
**So that** I can quickly see what matters and stay current

## Acceptance Criteria

### AC-1: Feed renders sections
**Given** announcements exist for my school **When** I open Announcements **Then** I see "Important" (P0) pinned on top, "Recent" listed below by date desc.

### AC-2: Empty state
**Given** no announcements **When** feed loads **Then** an empty illustration + localized message appears.

### AC-3: Cross-cutting
**Given** I am multi-school **When** I switch school **Then** feed re-fetches scoped to active `schoolId`; entries render in their `announcement.lang` font/direction.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested
- [ ] schoolId predicate on FetchDescriptor
- [ ] Entity content lang respected per row

## Files
- `hogwarts/features/announcements/views/feed-view.swift` — sections + list
- `hogwarts/features/announcements/viewmodels/feed-viewmodel.swift` — fetch + group
- `hogwarts/features/announcements/models/announcement-model.swift` — `@Model` with `schoolId`, `lang`, `priority`

## API Contract
- `GET /api/mobile/announcements?important=true|false` — returns `[ { id, title, body, lang, priority, published_at } ]`

## i18n Keys
- `messages.feed.title`
- `messages.feed.section.important`
- `messages.feed.section.recent`
- `messages.feed.empty`

## Tests
- `HogwartsTests/announcements/feed-viewmodel-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: ANN-002, ANN-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
