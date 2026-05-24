# ANN-004: Share announcement

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to share an announcement via the iOS share sheet
**So that** I can forward important updates outside the app

## Acceptance Criteria

### AC-1: Share sheet
**Given** I tap share on a detail **When** sheet appears **Then** title + universal-link URL + plain-text fallback are presented.

### AC-2: Cross-app share
**Given** I share to WhatsApp **When** received **Then** the universal link opens the announcement in-app (or web fallback).

### AC-3: Cross-cutting
**Given** entity `lang ≠ app lang` **When** sharing **Then** shared text uses entity content lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested share sheet
- [ ] Universal link includes `school_id` query (server enforces tenant)
- [ ] Entity content lang in shared payload

## Files
- `hogwarts/features/announcements/views/announcement-detail-view.swift` — `ShareLink`
- `hogwarts/features/announcements/helpers/share-builder.swift` — link + text composer

## API Contract
- (no new endpoint) — uses existing `:id` for deep link

## i18n Keys
- `common.share.title`
- `messages.share.subject`

## Tests
- `HogwartsTests/announcements/share-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: ANN-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, deep-link round-trip verified
